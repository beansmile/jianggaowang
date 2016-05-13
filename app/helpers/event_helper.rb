module EventHelper
  def format_event_time(event)
    start_date = event.start_at.to_date
    end_date = event.end_at.to_date
    options = { format: :long }
    if start_date == end_date
      l start_date, options
    else
      "#{l start_date, options}～#{l end_date, options}"
    end
  end
end
