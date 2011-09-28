require "jsonify"
require "colorize"
require_relative "config"

# attr_reader :name, :id, :time_from_prev_station, :destination_station, :origin_station, :station_id
 
def debug(message)
  puts "%s %s\n\n" % ["==>".black, message.to_s.green]
end

def sleep_for(sec)
  sleep(sec.to_f / 20)
end

Stations.each do |station|
  # This must be the first station
  if station.first_station?
    debug "This (#{station.name}) is the first station."
  else
    debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
    debug "Heading towards #{station.name}, there in #{station.time_from_prev_station} seconds."
    sleep_for(station.time_from_prev_station)
  end
end