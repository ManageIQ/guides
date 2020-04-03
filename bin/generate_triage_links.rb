#! /usr/bin/env ruby

require "pathname"
require "yaml"

params = YAML.load_file(Pathname.new(__dir__).join("triage.yml"))

links = params["repos"].product(params["links"]).map do |repo, link|
  header = "[#{repo["name"]} #{link["name"]}]:".ljust(60, " ")

  params = (link["params"] + repo["params"]).flatten.join(" ")
  url    = URI::HTTPS.build(:host => "github.com", :path => "/issues", :query => URI.encode_www_form(:q => params))

  "#{header}#{url}\n"
end

GENERATOR_LINE = "<!-- triage links generated after here -->\n".freeze

file  = Pathname.new(__dir__).join("..", "triage_process.md")
lines = file.readlines.take_while { |l| l != GENERATOR_LINE }
lines << GENERATOR_LINE
lines += links
file.write(lines.join)
