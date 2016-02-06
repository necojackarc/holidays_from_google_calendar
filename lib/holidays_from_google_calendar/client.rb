module HolidaysFromGoogleCalendar
  class Client
    def initialize(nation: "usa", language: "en", api_key: nil)
      @nation = nation
      @language = language
      @api_key = api_key
    end

    def retrieve_from_google_calendar(date_min: nil, date_max: nil)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.key = @api_key
      service.list_events(
        calendar_id,
        single_events: true,
        order_by: "startTime",
        time_min: date_to_time(date_min),
        time_max: date_to_time(date_max)
      )
    end

    private

    def calendar_id
      "#{@language}.#{@nation}#holiday@group.v.calendar.google.com"
    end

    def date_to_time(date)
      Time.parse(date.iso8601).iso8601
    end
  end
end
