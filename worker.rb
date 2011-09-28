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

# Simple mode, nothing goes wrong
modes[:simple] = lambda do |station|
  if station.first_station?
    debug "This (#{station.name}) is the first station."
  else
    debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
    debug "Heading towards #{station.name}, there in #{station.time_from_prev_station} seconds."
    sleep_for(station.time_from_prev_station, options[:time])
  end
end

# Advanced mode
# - trains might be late
modes[:advanced] = lambda do |station|
  if station.first_station?
    debug "This (#{station.name}) is the first station."
  else
    debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
    
    if rand(2) % 2 == 0
      debug "Ooops, train is late #{late = rand(29)} seconds, sending update to client.", :red
      time = station.time_from_prev_station + late
    else
      time = station.time_from_prev_station
    end
    
    debug "Heading towards #{station.name}, there in #{time} seconds."
    sleep_for(station.time_from_prev_station, options[:time])
  end
end

# Expert mode
# - warnings are being send out
# - trains might be late or too early
# - trains might stop at stations
modes[:expert] = lambda do |station|
  if station.first_station?
    debug "This (#{station.name}) is the first station."
  else
    debug "Leaving #{station.previous_station.name}, sending 'did_leave_station' to server."
    
    offset = 0
    
    if rand(5) == 0
      sleep_for(late = rand(29), options[:time])
      debug "Ooops, train is late #{late} seconds, sending update to client.", :red
    elsif rand(5) == 0
      offset = -1 * rand(20)
      debug "Ooops, train is to early (#{offset}) seconds.", :red
    end
    
    time = station.time_from_prev_station + offset
    
    debug "Heading towards #{station.name}, there in #{time} seconds."
    sleep_for(time, options[:time])
    
    if rand(5) == 0
      debug "Stopping at #{station.name} for #{late = rand(100)} seconds.", :red
      sleep_for(late, options[:time])
    end
    
    if rand(10) == 0
      debug "Sending alert to client!", :red
    end
  end
end

debug "Starting in #{options[:mode]} mode, loop is #{options[:loop]}, time constant is set to #{options[:time]}.", :green

Stations.each do |station|
  modes[options[:mode]].call(station)
end