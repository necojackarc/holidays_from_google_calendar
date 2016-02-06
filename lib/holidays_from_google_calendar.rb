require "holidays_from_google_calendar/version"
require "holidays_from_google_calendar/configuration"
require "holidays_from_google_calendar/client"
require "holidays_from_google_calendar/holiday"

require "google/apis/calendar_v3"

require "active_support"
require "active_support/core_ext"

module HolidaysFromGoogleCalendar
  class Holidays
    class << self
      def configure
        @configuration = Configuration.new
        yield @configuration
        @client = Client.new(@configuration.to_h)
      end

      def in_year(date)
        response = @client.retrieve_from_google_calendar(
          date_min: date.beginning_of_year,
          date_max: date.end_of_year + 1.day
        )
        pack_response_in_struct(response)
      end

      def in_month(date)
        response = @client.retrieve_from_google_calendar(
          date_min: date.beginning_of_month,
          date_max: date.end_of_month + 1.day
        )
        pack_response_in_struct(response)
      end

      def holiday?(date)
        return true if date.wday.in?([0, 6]) # If Sunday or Saturday
        response = @client.retrieve_from_google_calendar(date_min: date, date_max: date + 1.day)
        response.items.size > 0
      end

      private

      def pack_response_in_struct(response)
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
end
