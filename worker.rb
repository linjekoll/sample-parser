require "jsonify"
require "colorize"
require_relative "config"

# attr_reader :name, :id, :time_from_prev_station, :destination_station, :origin_station, :station_id
 
Stations.each do |station|
  # This must be the first station
  if station.first_station?
    puts "First station".green
  elsif station.end_station?
    puts "End station".green
  else
    puts "Mindle station".blue
  end
end