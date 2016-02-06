require "holidays_from_google_calendar/version"

require "google/apis/calendar_v3"

require "active_support"
require "active_support/core_ext"

module HolidaysFromGoogleCalendar
  class Holidays
    Holiday = Struct.new(:name, :date)

    def initialize(nation: "usa", language: "en", api_key: nil)
      @nation = nation
      @language = language
      @api_key = api_key
    end

    def in_year(date)
      response = retrieve_from_google_calendar(
        date_min: date.beginning_of_year,
        date_max: date.end_of_year + 1.day
      )
      pack_response_in_struct(response)
    end

    def in_month(date)
      response = retrieve_from_google_calendar(
        date_min: date.beginning_of_month,
        date_max: date.end_of_month + 1.day
      )
      pack_response_in_struct(response)
    end

    def holiday?(date)
      return true if date.wday.in?([0, 6]) # If Sunday or Saturday
      response = retrieve_from_google_calendar(date_min: date, date_max: date + 1.day)
      response.items.size > 0
    end

    private

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

    def calendar_id
      "#{@language}.#{@nation}#holiday@group.v.calendar.google.com"
    end

    def date_to_time(date)
      Time.parse(date.iso8601).iso8601
    end

    def pack_response_in_struct(response)
      response.items.reduce([]) do |array, item|
        array.push(Holiday.new(item.summary, Date.parse(item.start.date)))
      end
    end
  end
end
