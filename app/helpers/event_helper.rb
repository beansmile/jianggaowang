module EventHelper
  def format_event_time(event)
    if event.start_time == event.end_time
      event.start_time
    else
      "#{event.start_time}～#{event.end_time}"
    end
  end
end
