require "jsonify"
require "colorize"
require "optparse"
require_relative "config"

# attr_reader :name, :id, :time_from_prev_station, :destination_station, :origin_station, :station_id
 
def debug(message, color = :yellow)
  puts "%s %s\n\n" % ["==>".black, message.to_s.send(color)]
end

options = {}

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: worker.rb [options]"

  # Define the options, and what they do
  options[:mode] = :simple
  opts.on( '-m', '--mode', "Start up mode [simple, beginner, expert]" ) do |mode|
    options[:verbose] = mode.to_sym
  end

  options[:loop] = false
  opts.on( '-l', '--loop', "Should be continue forever?" ) do |mode|
    options[:loop] = !! mode
  end
  
  options[:time] = 20
  opts.on( '-t', '--time', "Time constant" ) do |time|
    options[:time] = time.to_i
  end
  
  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

def sleep_for(sec, time)
  sleep(sec.to_f / time)
end

modes = {}
modes[:simple] = lambda do |station|
  if station.first_station?
    debug "This (#{station.name}) is the first station."
  else
    debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
    debug "Heading towards #{station.name}, there in #{station.time_from_prev_station} seconds."
    sleep_for(station.time_from_prev_station, options[:time])
  end
end

debug "Starting in #{options[:mode]} mode, loop is #{options[:loop]}, time constant is set to #{options[:time]}.", :green

Stations.each do |station|
  modes[options[:mode]].call(station)
end