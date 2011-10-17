require "rest-client"

class Station
  attr_reader :name, :id, :next_station, :previous_station, :time_to_next_station, :sid
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
  end

  def time_from_prev_station
    @time_from_prev_station.to_i
  end
  
  def end_station?
    ! time_to_next_station
  end
end