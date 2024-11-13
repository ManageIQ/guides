## Using test recordings to populate a development database

One of the more difficult tasks when developing for ManageIQ is when a feature requires some
provider specific inventory to be present in your local database when you don't have
access to the provider.

Most providers have something called a "VCR Cassette" to aid in running spec tests
without access to a real provider.  It is a YAML file which "replays" HTTP calls back
to a calling method making it appear that it is interacting with a real native provider.

While this is critical for running specs, we can also make use of this for development
by treating it as an offline dump of real inventory data.  It is possible to configure
VCR in a development environment and use a VCR cassette when running a refresh, thereby
creating inventory records in our development database from the data stored in the VCR.

VCR is fairly unforgiving, if any data doesn't match it will throw an exception and
fail the refresh so it is critical to set everything up the same way it would run in
spec tests.  Specifically, things like provider hostname/port/region and authentication
userid/password have to match what is in the VCR cassette or the vcr gem won't recognize
the request.

For this example we'll use an Amazon provider.  We first have to create a "fake" Amazon
provider to use for the VCR backed refresh.

```ruby
vcr_region   = "us-east-1"
vcr_userid   = "AMAZON_CLIENT_ID"
vcr_password = "AMAZON_CLIENT_SECRET"

ems = ManageIQ::Providers::Amazon::CloudManager.create!(
  :name             => "AWS VCR",
  :provider_region  => vcr_region,
  :default_userid   => vcr_userid,
  :default_password => vcr_password,
  :zone             => Zone.default_zone
)
```

We can find these values by looking at the amazon provider's vcr cassette file,
`src/manageiq/manageiq-providers-amazon/spec/vcr_cassettes/manageiq/providers/amazon/cloud_manager/refresher_inventory_object.yml`

We can see that `'us-east-1'` is used as the region in the URIs, and in the Rails credentials
and `spec/factories/ext_management_system.rb` files we can see that `AMAZON_CLIENT_ID` and
`AMAZON_CLIENT_SECRET` are used for the userid and password values for the authentication.

Now that we have our provider record created we can configure VCR and run the refresh:

```ruby
require "vcr"
VCR.configure do |config|
  config.cassette_library_dir = ManageIQ::Providers::Amazon::Engine.root.join("spec/vcr_cassettes").to_s
  config.hook_into :webmock
end
VCR.use_cassette("manageiq/providers/amazon/cloud_manager/refresher_inventory_object") { EmsRefresh.refresh(ems) }
```

Each provider can have slight variances in the names of their VCR cassettes so it is
best to review the spec tests in the provider you are trying to replicate.

Now you should have inventory in your database for this provider:
```ruby
>> ems.vms.count
=> 9
>> ems.miq_templates.count
=> 243
>> ems.orchestration_templates.count
=> 0
>> ems.cloud_networks.count                        
=> 5
