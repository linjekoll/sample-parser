require "jsonify"
require "colorize"
require_relative "config"

Stations.each do |station|
  if station["time_from_prev_station"]
    puts "time_from_prev_station is NOT nil".green
  else
    puts "time_from_prev_station is nil".red
  end
end