## Writing VCR Provider Spec Tests

So you've just done a refresh with your new provider, congratulations.  Now it is time to make sure it continues to work by writing some tests.

### VCR

How do you test code which makes API calls without having access to a live system?  There is a ruby gem called [VCR](https://github.com/vcr/vcr) which "records" HTTP API calls and then plays them back later.  This allows us to test code which would normally have to point to a live API without having to stub every single method call.

The results of the recording are stored in the VCR `config.cassette_library_dir` as YAML files with request/response pairs.  VCR will automatically stub the HTTP layer for you, and when it recognizes a request it will replay the saved response for you.  This allows for mostly normal operation while running in an isolated CI system.

### Configuration

If you generated your provider plugin with the `--vcr` flag then the VCR configuration should have already been done for you.  If not simply add the following to the bottom of your `spec/spec_helper.rb` file:
```ruby
VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com' if ENV['CI']
  config.cassette_library_dir = ManageIQ::Providers::AwesomeCloud::Engine.root.join('spec/vcr_cassettes')
end
```

The next thing we have to take care of is hiding "secrets".  Since the VCR YAML files will be committed to source control it is critical that private information like passwords do not make it into these files.

VCR handles this with the `config.define_cassette_placeholder` option.  You provide VCR with a string that you want to be replaced, and then what you want it to be replaced with.  This allows for hostnames / passwords / etc... to be used when recording the cassette but the values will not be written to the resulting YAML files.

ManageIQ has a pattern to help you with this, simply create a `config/secrets.defaults.yml` file:
```yaml
---
test:
  awesome_cloud_defaults: &awesome_cloud_defaults
    access_key: AWESOME_CLOUD_ACCESS_KEY
    secret_key: AWESOME_CLOUD_SECRET_KEY
  awesome_cloud:
    <<: *awesome_cloud_defaults
```

Then create a `config/secrets.yml` file (this file will not be committed and should be in your .gitignore):
```yaml
---
test:
  awesome_cloud:
    access_key: "YOUR_REAL_ACCESS_KEY"
    secret_key: "YOUR_REAL_SECRET_KEY"
```

Then add the following to your `VCR.configure` block in `spec/spec_helper.rb` after setting the `config.cassette_library_dir`:
```ruby
  secrets = Rails.application.secrets
  secrets.awesome_cloud.each do |key, val|
    config.define_cassette_placeholder(secrets.awesome_cloud_defaults[key]) { val }
  end
```

### Writing the tests

Now that we have VCR configured it is time to start writing your spec tests.  First we will start with the Refresher to test the refresh process of your new provider.

Create a file called `spec/models/manageiq/providers/awesome_cloud/cloud_manager/refresher_spec.rb`:
```ruby
describe ManageIQ::Providers::AwesomeCloud::CloudManager::Refresher do
  include Spec::Support::EmsRefreshHelper

  let(:zone) { EvmSpecHelper.create_guid_miq_server_zone.last }
  let!(:ems) do
    FactoryBot.create(:ems_awesome_cloud, :zone => zone).tap do |ems|
      access_key, secret_key = Rails.application.secrets.awesome_cloud.values_at(:access_key, :secret_key)

      ems.update_authentication(:default => {:userid => access_key, :password => secret_key})
    end
  end

  describe ".refresh" do
    context "full refresh" do
      it "Performs a full refresh" do
        # Run the refresh twice to catch any record duplication across
        # multiple refreshes
        2.times do
          with_vcr { described_class.refresh([ems]) }
        end

        # Reload the ems record to ensure all associations are up to date
        ems.reload

        # Add your tests here
        assert_ems
        assert_specific_vm
        assert_specific_flavor
        assert_specific_template
        # etc...
      end

      def assert_ems
        expect(ems.last_refresh_error).to be_nil
        expect(ems.last_refresh_date).not_to be_nil
        expect(ems.last_inventory_date).not_to be_nil

        # Update the counts to match what you have in your test environment
        # expect(ems.vms.count).to eq(1)
        # expect(ems.flavors.count).to eq(2)
        # expect(ems.miq_templates.count).to eq(3)
        # etc...
      end
    end
  end
end
```

With that file created run the specs with the `rspec` command:
```bash
bundle exec rspec spec/models/manageiq/awesome_cloud/cloud_manager/refresher_spec.rb
```

That should run through and end up creating a file in `spec/vcr_cassettes/manageiq/providers/awesome_cloud/cloud_manager/refresher.yml`

From now on when you run the specs it will use the results in the file rather than hitting the API directly.

Now fill out the refresher_spec.rb file with more checks to ensure that inventory is collected and associated properly.

### Updating the VCR cassettes

Now that you have your specs recorded, what happens if you want to collect something new?  Like you now want to start fetching floating IPs or Cloud Volumes?

It is simple to re-record your VCR cassette, simply remove the file then rerun the specs against the same environment:
```bash
rm spec/vcr_cassettes/manageiq/providers/awesome_cloud/cloud_manager/refresher.yml
bundle exec rspec spec/models/manageiq/awesome_cloud/cloud_manager/refresher_spec.rb
```

Make sure that you have your `config/secrets.yml` file still present, you might have to update the expected counts as things in your environment have likely changed but you now should have an updated VCR cassette.
