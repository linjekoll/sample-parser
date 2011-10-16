# -*- encoding : utf-8 -*-
require "rest-client"
# Events
# "did_leave_station",
# "update",
# "alert"
# event: "did_leave_station",
# id: "89824",
# origin_station: 8998235,
# destination_station: 898345,
# station_id: 123123,
# arrival_time: 1235,
# alert_message: "oops!",
# line_id: 2342,
# provider_id: 23,

class Event
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    @event         = nil
    @alert_message = nil
    @api_key       = "d58e3582afa99040e27b92b13c8f2280"
  end
  
  def set(args)
    tap {
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    }
  end
  
  def did_leave_station
    tap { @event = :did_leave_station }
  end
  
  def update
    tap { @event = :update }
  end
  
  def alert
    tap { @event = :alert }
  end
  
  def push!
    raw = {
      event: @event,
      origin_station: 8998235 || @origin_station,
      destination_station: 898345 || @destination_station,
      station_id: @station_id || 123123,
      arrival_time: @arrival_time || 1235, 
      alert_message: @alert_message,
      line_id: @line_id || 2342,
     }.to_json
     
     @event = nil
     RestClient.get("http://localhost:3000/#{@api_key}/providers/#{@provider_id}/journeys/#{@journey_id}")
  end
end

stations = JSON.parse(
  <<-long
  [{
     "name": "Mölndal centrum",
     "id": 1,
     "time_from_prev_station": null,
     "destination_station": 4,
     "origin_station": null,
     "sid": "00012110",
     "time_to_next_station": 120
   },
   {
     "name": "Mölndals sjukhus",
     "id": 2,
     "time_from_prev_station": 120,
     "destination_station": 4,
     "origin_station": 1,
     "sid": "00012130",
     "time_to_next_station": 60
   },
   {
     "name": "Lackarebäck",
     "id": 3,
     "time_from_prev_station": 60,
     "destination_station": 4,
     "origin_station": 2,
     "sid": "00012140",
     "time_to_next_station": 60
   },
   {
     "name": "Krokslätts Fabriker",
     "id": 4,
     "time_from_prev_station": 60,
     "destination_station": 4,
     "origin_station": 3,
     "sid": "00012141",
     "time_to_next_station": null
  }]
  long
)

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

Stations = stations.map do |station|
  Station.new(station)
end

Stations.map do |station|
  station.stations(Stations)
end

provider_id = 1
line_id     = 1
alert_messages = ["Tram is on fire"]
