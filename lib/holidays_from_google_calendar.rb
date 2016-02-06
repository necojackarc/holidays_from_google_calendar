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

    def on_date(date)
      @client.retrieve(
        date_min: date,
        date_max: date
      )
    end

    def in_year(date)
      @client.retrieve(
        date_min: date.beginning_of_year,
        date_max: date.end_of_year
      )
    end

    def in_month(date)
      @client.retrieve(
        date_min: date.beginning_of_month,
        date_max: date.end_of_month
      )
    end

    def holiday?(date)
      return true if date.wday.in?([0, 6]) # If Sunday or Saturday
      @client.retrieve(date_min: date, date_max: date).size > 0
    end
  end
end
