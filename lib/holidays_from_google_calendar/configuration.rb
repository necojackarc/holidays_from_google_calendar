module HolidaysFromGoogleCalendar
  class Configuration
    CALENDAR_ATTRIBUTES = %i(nation language).freeze
    CREDENTIAL_ATTRIBUTES = %i(api_key).freeze
    CACHE_ATTRIBUTES = %i(enable size).freeze

    DEFAULT_CACHE_SIZE = 1_000

    attr_accessor :calendar, :credential, :cache

    def initialize
      @calendar = {
        nation: "japanese",
        language: "ja"
      }

      @cache = {
        enable: true,
        max_size: DEFAULT_CACHE_SIZE
      }
    end
  end
end
