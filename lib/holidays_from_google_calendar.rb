require "active_support"
require "active_support/core_ext"
require "google/apis/calendar_v3"

require "holidays_from_google_calendar/cache"
require "holidays_from_google_calendar/cache_unit"
require "holidays_from_google_calendar/client"
require "holidays_from_google_calendar/configuration"
require "holidays_from_google_calendar/holiday"
require "holidays_from_google_calendar/version"

module HolidaysFromGoogleCalendar
  class Holidays
    def initialize
      @configuration = Configuration.new
      yield @configuration
      @client = Client.new(@configuration)
    end

    def in_year(date)
      date = Date.parse(date.iso8601) if date.is_a?(Time)
      @client.retrieve(
        date_min: date.beginning_of_year,
        date_max: date.end_of_year + 1.day
      )
    end

    def in_month(date)
      date = Date.parse(date.iso8601) if date.is_a?(Time)
      @client.retrieve(
        date_min: date.beginning_of_month,
        date_max: date.end_of_month + 1.day
      )
    end

    def holiday?(date)
      date = Date.parse(date.iso8601) if date.is_a?(Time)
      return true if date.wday.in?([0, 6]) # If Sunday or Saturday
      holiday = @client.retrieve(date_min: date, date_max: date + 1.day).first
      holiday && holiday.date == date
    end
  end
end
