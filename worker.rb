require "jsonify"
require "colorize"
require "optparse"
require "./lib/event"
require "./lib/station"
 
def debug(message, color = :yellow)
  puts "%s %s\n\n" % ["==>".black, message.to_s.send(color)]
end

def sleep_for(sec, time)
  sleep(sec.to_f / time)
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

provider_id = 1
journey_id  = rand(10*10)
line_id     = "4"
event       = Event.new(provider_id: provider_id, line_id: line_id)
stations    = JSON.parse(File.read("static/stations.json")).map { |station| Station.new(station) }
modes       = {}

# Simple mode, nothing goes wrong
modes[:simple] = lambda do |station|
  if station.end_station?
    debug("#{station.name} is the end station"); return
  end
  
  event.set({
    journey_id: journey_id,
    arrival_time: Time.now.to_i + station.time_to_next_station, 
    next_station: station.next_station,
    previous_station: station.previous_station,
    sid: station.sid,
  }).did_leave_station.push!
  
  debug "Leaving #{station.name}, sending 'did_leave_station' to server."
  debug "Heading towards #{station.name}, there in #{station.time_to_next_station} seconds."
  sleep_for(station.time_to_next_station, options[:time])
end

debug "Starting in #{options[:mode]} mode, loop is #{options[:loop]}, time constant is set to #{options[:time]}.", :green

begin
  stations.each do |station|
    modes[options[:mode]].call(station)
    sleep(rand(10)) # Simulates the train standing still on station
  end
  
  # This should be a new journey
  journey_id = journey_id + 1
end while options[:loop]
