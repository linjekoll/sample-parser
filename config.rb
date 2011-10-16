# -*- encoding : utf-8 -*-
stations = JSON.parse(
  <<-long
  [{
     "name": "Mölndal centrum",
     "id": 1,
     "time_from_prev_station": null,
     "destination_station": 4,
     "origin_station": null,
     "sid": "00012110"
   },
   {
     "name": "Mölndals sjukhus",
     "id": 2,
     "time_from_prev_station": 120,
     "destination_station": 4,
     "origin_station": 1,
     "sid": "00012130"
   },
   {
     "name": "Lackarebäck",
     "id": 3,
     "time_from_prev_station": 60,
     "destination_station": 4,
     "origin_station": 2,
     "sid": "00012140"
   },
   {
     "name": "Krokslätts Fabriker",
     "id": 4,
     "time_from_prev_station": 60,
     "destination_station": 4,
     "origin_station": 3,
     "sid": "00012141"
  }]
  long
)

class Station
  attr_reader :name, :id, :destination_station, :origin_station, :station_id
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

Stations = stations.map do |station|
  Station.new(station)
end

Stations.map do |station|
  station.stations(Stations)
end

provider_id = 1
line_id     = 1
alert_messages = ["Tram is on fire"]
