require "rest-client"

class Station
  attr_reader :name, :id, :destination_station, :origin_station, :station_id, :time_to_next_station, :sid
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
  end

  def first_station?
    ! @time_from_prev_station
  end

  def end_station?
    @destination_station == @station_id
  end

  def time_from_prev_station
    @time_from_prev_station.to_i
  end

  def stations(stations)
    @stations = stations
  end

  def previous_station
    @stations[@origin_station]
  end
end