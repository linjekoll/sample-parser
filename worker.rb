require "jsonify"
require "colorize"
require "optparse"
require "./lib/event"
require "./lib/station"
require "./config"
 
def debug(message, color = :yellow)
  puts "%s %s\n\n" % ["==>".black, message.to_s.send(color)]
end

options = {}

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: worker.rb [options]"

  # Define the options, and what they do
  options[:mode] = :simple
  opts.on( '-s', '--simple', "Simple mode" ) do |mode|
    options[:mode] = :simple
  end

  opts.on( '-a', '--advanced', "Advanced mode" ) do |mode|
    options[:mode] = :advanced
  end
  
  opts.on( '-e', '--expert', "Expert mode" ) do |mode|
    options[:mode] = :expert
  end
  
  options[:loop] = false
  opts.on( '-l', '--loop', "Should be continue forever?" ) do |mode|
    options[:loop] = !! mode
  end
  
  options[:time] = 20
  opts.on( '-t', '--time', "Set time to normal, otherwise 20" ) do |time|
    options[:time] = 1
  end
  
  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

def sleep_for(sec, time)
  sleep(sec.to_f / time)
end

modes = {}

#### A station
# "id": 2,
# "name": "Mölndals sjukhus",
# "next_station": 4,
# "previous_station": 1,
# "sid": "00012130",
# "time_to_next_station": 60

#### Data that should be pushed
# event: "event",
# next_station: 8998235,
# previous_station: 898345,
# arrival_time: 1318843870,
# alert_message: "oops!",
# line_id: 2342

#### Url data, that should be push through the url
# api_key: d58e3582afa99040e27b92b13c8f2280
# provider_id: 123123
# journey_id: 123123123

# Static data
# journey_id should be incremented along the way
provider_id = 1
journey_id  = 1
line_id     = "4"

event = Event.new(provider_id: provider_id, line_id: line_id)

# Simple mode, nothing goes wrong
modes[:simple] = lambda do |station|
  event.set({
    journey_id: journey_id,
    arrival_time: Time.now.to_i + station.time_to_next_station, 
    next_station: station.next_station,
    previous_station: station.previous_station,
    sid: station.sid,
  }).did_leave_station.push!
  
  debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
  debug "Heading towards #{station.name}, there in #{station.time_from_prev_station} seconds."
  sleep_for(station.arrival_time, options[:time])
end

debug "Starting in #{options[:mode]} mode, loop is #{options[:loop]}, time constant is set to #{options[:time]}.", :green

stations = JSON.parse(File.read("static/stations.json")).map { |station| Station.new(station) }
stations.map { |station| station.stations(stations) }

begin
  stations.each do |station|
    modes[options[:mode]].call(station)
  end
  
  # This should be a new journey
  journey_id = journey_id + 1
end while options[:loop]
