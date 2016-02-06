module HolidaysFromGoogleCalendar
  class Client
    def initialize(configuration)
      @nation = configuration.calendar[:nation]
      @language = configuration.calendar[:language]
      @api_key = configuration.credential[:api_key]
    end

    def retrieve_from_google_calendar(date_min: nil, date_max: nil)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.key = @api_key

      response = service.list_events(
        calendar_id,
        single_events: true,
        order_by: "startTime",
        time_min: date_to_time(date_min),
        time_max: date_to_time(date_max)
      )
      pack_response_in_object(response)
    end

    private

    def calendar_id
      "#{@language}.#{@nation}#holiday@group.v.calendar.google.com"
    end

    def date_to_time(date)
      Time.parse(date.iso8601).iso8601
    end

    def pack_response_in_object(response)
      response.items.reduce([]) do |array, item|
        holiday = Holiday.new(
          name: item.summary,
          date: Date.parse(item.start.date)
        )
        array.push(holiday)
      end
    end
  end
end
