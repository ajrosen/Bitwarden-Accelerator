#!/usr/bin/ruby

# Manage favicons
#
# A single command-line argument must be one of:

# clean: Remove all files in the favicons directory
# symlink: Only create symlinks for missing icons
# fetch: Fetch stale icons or create symlinks if the fetch fails

require 'date'.freeze
require 'fileutils'.freeze
require 'json'.freeze
require 'net/http'.freeze
require 'uri'.freeze

##################################################
# Write a message to $stderr if ENV['DEBUG'] is '1'
#
# @param message [String] The message
# rubocop: disable Style/StderrPuts
def slog(message)
  $stderr.puts(message) if ENV['DEBUG'] == '1'
end
# rubocop: enable Style/StderrPuts

##################################################
# Write a warning if ENV['DEBUG'] is '1'
#
# @param message [String] The message
def wlog(message)
  warn(message, uplevel: 1) if ENV['DEBUG'] == '1'
end

##################################################
# Clean the favicons directory

def clean
  Dir.chdir('..')
  slog("Removing #{Dir.getwd}/favicons")
  FileUtils.rm_r('favicons', force: true)
end

##################################################
# Fetch an icon
#
# @param host [String] The URI to fetch icon from
# @param redirects [Integer] The maximum number of redirects we will follow
# @return [HTTPResponse] The response
# @raise Net::HTTPBadResponse Also raised if we run out of redirects
def fetch_icon(host, redirects = MAX_REDIRECTS)
  raise Net::HTTPBadResponse, 'Too many redirects' if redirects.negative?

  retval = Net::HTTP.get_response(host)
  retval = fetch_icon(URI(retval['Location']), redirects - 1) if retval.is_a? Net::HTTPRedirection
  retval
end

##################################################
# Create a symlink to the default icon
#
# @param host [String] The hostname of an item's URI
# @raise Errno::EEXIST
def symlink(host)
  icon = "#{ENV['alfred_preferences']}/workflows/#{ENV['alfred_workflow_uid']}/icon.png"

  File.symlink(icon, host)
end

##################################################
# Fetch a missing or stale icon
#
# An icon is stale if the item in Bitwarden has been modified more
# recently than the icon file
#
# @param host [String] The hostname of an item's URI
# @param rdate [String] The item's revision date
# rubocop: disable Metrics/MethodLength, Metrics/AbcSize
def fetch(host, rdate)
  # Check if item has been modified since the file/symlink was created
  if File.exist? host
    mtime = File.lstat(host).mtime.to_i
    rtime = DateTime.strptime(rdate, '%FT%T', Date::ENGLAND).strftime('%s').to_i

    return if (mtime < rtime) && (!File.symlink? host)
  end

  # Fetch the icon
  res = fetch_icon(URI(format(SERVICE, host)))

  # Only write the body if we get 200
  if res.is_a? Net::HTTPOK
    FileUtils.rm_f(host)
    File.write(host, res.body)
  else
    symlink(host)
  end
end
# rubocop: enable Metrics/MethodLength, Metrics/AbcSize

##################################################
# Variables

# Favicons APIs
services = {
  Bitwarden: 'https://icons.bitwarden.net/%s/icon.png',
  DuckDuckGo: 'https://icons.duckduckgo.com/ip3/%s.ico',
  Favicone: 'https://favicone.com/%s?s=64',
  Google: 'https://www.google.com/s2/favicons?domain=%s&sz=64',
  'Icon Horse': 'https://icon.horse/icon/%s'
}.freeze

begin
  SERVICE = services[ENV['favicons'].to_sym].freeze
  exit if SERVICE.is_a? NilClass
rescue NoMethodError => e
  wlog(e.message)
  exit
end

# Maximum number of redirects allowed
MAX_REDIRECTS = 1

# Icons fetched
fetched = []

##################################################
# Go to favorites icons directory, creating it first if necessary

begin
  favicons_dir = "#{ENV['alfred_workflow_cache']}/favicons"

  Dir.mkdir(favicons_dir) unless Dir.exist? favicons_dir
  Dir.chdir(favicons_dir)
rescue TypeError
  abort 'alfred_workflow_data environment variable not set'
rescue StandardError => e
  abort e.message
end

##################################################
# Check command line argument

slog("Command = #{ARGV[0]}")

case ARGV[0]
when 'clean'
  clean
  exit
when 'fetch'
  command = 'fetch'
when 'symlink'
  command = 'symlink'
else
  abort 'Usage: favicons clean | fetch | symlink'
end

##################################################
# Get items from Bitwarden

begin
  file = "#{ENV['alfred_workflow_cache']}/data/items"

  slog("Getting items from #{file}")
  items = JSON.parse(File.read(file))
rescue StandardError => e
  wlog(e.message)
  exit(-1)
end

##################################################
# Loop over each item
items['data']['data'].each do |item|
  # Loop over item's URIs
  item['login']['uris'].each do |uri|
    # We only need the host of the URI
    host = URI(uri['uri']).host

    # slog("#{command} #{host}")

    # Once is enough
    next if fetched.include? host

    fetched.append(host)

    symlink(host) if command == 'symlink'
    fetch(host, item['revisionDate']) if command == 'fetch'
  end
rescue SignalException
  exit
rescue Errno::EEXIST
  # May be thrown by symlink
rescue NoMethodError
  # It's not an error for item['login']['uris'] to be null
end
