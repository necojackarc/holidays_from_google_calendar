module HolidaysFromGoogleCalendar
  class Client
    def initialize(configuration)
      @nation = configuration.calendar[:nation]
      @language = configuration.calendar[:language]
      @api_key = configuration.credential[:api_key]
      @cache = Cache.new(configuration.cache)

      return unless configuration.preload[:enable]
      preload(configuration.preload[:date_range])
    end

    def retrieve(date_min: nil, date_max: nil)
      date_min = Date.parse(date_min.iso8601)
      date_max = Date.parse(date_max.iso8601)

      if @cache.enabled?
        cached_holidays = @cache.retrieve(date_min, date_max)
        return cached_holidays if cached_holidays
      end

      retrieve_from_google_calendar(date_min, date_max).tap do |holidays|
        @cache.cache(holidays, date_min, date_max) if @cache.enabled?
      end
    end

    private

    def retrieve_from_google_calendar(date_min, date_max)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.key = @api_key

      response = service.list_events(
        calendar_id,
        single_events: true,
        order_by: "startTime",
        time_min: date_to_time(date_min),
        time_max: date_to_time(date_max + 1.day)
      )
      pack_response_in_object(response, date_min, date_max)
    end

    def calendar_id
      "#{@language}.#{@nation}#holiday@group.v.calendar.google.com"
    end

    def date_to_time(date)
      Time.parse(date.iso8601).iso8601
    end

    def pack_response_in_object(response, date_min, date_max)
      response.items.reduce([]) do |array, item|
        holiday = Holiday.new(
          name: item.summary,
          date: Date.parse(item.start.date)
        )

        if date_min <= holiday.date && holiday.date <= date_max
          array.push(holiday)
        else
          array # Do nothing
        end
      end
    end

    def preload(date_range)
      retrieve(
        date_min: Date.current - date_range,
        date_max: Date.current + date_range
      )
    end
  end
end
