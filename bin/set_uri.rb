#!/usr/bin/env ruby

# Add or change an item's URI
#
# set_uri.rb uriop old_uri new_uri

require 'fileutils'.freeze
require 'json'.freeze

##################################################
# Get command line arguments

uriop = ARGV[0]
old_uri = ARGV[1]
new_uri = ARGV[2]

begin
  # Get item from Bitwarden
  file = "#{ENV['alfred_workflow_cache']}/data/items"
  items = JSON.parse(File.read(file))

  # Get the item's uris
  item = items['data']['data'].select { |i| i['id'] == ENV['objectId'] }
  uris = item[0]['login']['uris']

  # Perform the operation
  case uriop
  when 'add' then uris.push({ :match => nil, :uri => new_uri })
  when 'edit' then uris.each { |i| i['uri'] = new_uri if (i['uri'] == old_uri) }
  when 'delete' then uris.delete_if { |i| i['uri'] == old_uri }
  else exit(-1)
  end

  # Print the results
  puts uris.uniq.to_json
rescue StandardError => e
  warn(e, uplevel: 1) if ENV['DEBUG'] == '1'
  exit(-1)
end
