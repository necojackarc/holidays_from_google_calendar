module HolidaysFromGoogleCalendar
  class Configuration
    CALENDAR_ATTRIBUTES = %i(nation language).freeze
    CREDENTIAL_ATTRIBUTES = %i(api_key).freeze

    attr_accessor :calendar, :credential

    def initialize
      @calendar = {
        nation: "japanese",
        language: "ja"
      }
    end
  end
end
