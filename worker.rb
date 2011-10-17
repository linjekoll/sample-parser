require "jsonify"
require "colorize"
require "optparse"
require_relative "config"
 
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

# event: "did_leave_station",
# origin_station: 8998235,
# destination_station: 898345,
# station_id: 123123,
# arrival_time: 1235,
# alert_message: "oops!",
# line_id: 2342,
# provider_id: 23,

event = Event.new(provider: 1, line_id: 2)

# Simple mode, nothing goes wrong
modes[:simple] = lambda do |station|
  if station.first_station?
    debug "This (#{station.name}) is the first station."
  else
    event.set({
      journey_id: station.id, 
      arrival_time: station.time_to_next_station, 
      destination_station: station.destination_station,
      station_id: station.sid
    }).did_leave_station.push!
    
    debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
    debug "Heading towards #{station.name}, there in #{station.time_from_prev_station} seconds."
    sleep_for(station.time_from_prev_station, options[:time])
  end
end

debug "Starting in #{options[:mode]} mode, loop is #{options[:loop]}, time constant is set to #{options[:time]}.", :green

begin
  Stations.each do |station|
    modes[options[:mode]].call(station)
  end
end while options[:loop]
