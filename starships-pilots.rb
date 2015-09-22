#!/usr/bin/env ruby
# Tested with Ruby 1.9.3

# Load Bundler for Gem Files
require 'bundler/setup'
Bundler.require(:default)
puts '======================================'
puts ' _____  _    _    ___  ______ _____'
puts '/  ___|| |  | |  / _ \ | ___ \_   _|'
puts '\ `--. | |  | | / /_\ \| |_/ / | |'
puts ' `--. \| |/\| | |  _  ||  __/  | |'
puts '/\__/ /\  /\  / | | | || |    _| |_'
puts '\____/  \/  \/  \_| |_/\_|    \___/'
puts "Starhips-Pilots"
puts '======================================'
puts "Starting"



# ----------------------------------------------
# Get List of StarShips
starships = Array.new

page = JSON.parse(RestClient.get 'http://swapi.co/api/starships/')
starships.concat page['results']
puts "Processing Starships, Count: #{page['count']}"
while page['next']
  #puts "Pagination: Starting Next(#{page['next']})"
  nextpage = JSON.parse(RestClient.get page['next'])
  starships.concat nextpage['results']
  page = nextpage
  #puts page['next']
end

# ----------------------------------------------
# Get List of People
people = Hash.new

page = JSON.parse(RestClient.get 'http://swapi.co/api/people/')
page['results'].each {|p| people[p['url']] = p}
puts "Processing Pilots, Count: #{page['count']}"
while page['next']
  #puts "Pagination: Starting Next(#{page['next']})"
  nextpage = JSON.parse(RestClient.get page['next'])
  page = nextpage
  page['results'].each {|p| people[p['url']] = p}
  #puts page['next']
end


# ----------------------------------------------
# Render List

starships.each do |starship|
  puts "Name: #{starship['name']}"
  # Skip Repetitive
  puts "Model: #{starship['model']}" unless starship['model'] == starship['name']
  puts "Class: #{starship['starship_class'].capitalize}"
  puts "Manufacturer: #{starship['manufacturer']}"
  puts "Crew: #{starship['crew']}"
  puts "Maximum Atmospheric Speed: #{starship['max_atmosphering_speed']}"
  puts "Cargo: #{starship['cargo_capacity']}"

  if starship['pilots'].count == 0
    puts "Pilots: Unknown"
  else
    puts "Pilots:"
    starship['pilots'].each do |pilot|
      puts "  " + people[pilot]['name']
    end
  end
  puts "------------------------------"
end
