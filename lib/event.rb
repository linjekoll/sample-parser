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
     RestClient.get("http://46.16.232.244:3001/#{@api_key}/providers/#{@provider_id}/journeys/#{@journey_id}")
  end
end