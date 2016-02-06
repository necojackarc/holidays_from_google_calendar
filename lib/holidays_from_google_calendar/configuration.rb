module HolidaysFromGoogleCalendar
  class Configuration
    DEFAULT_CACHE_SIZE = 1_000

    attr_accessor :calendar, :credential, :cache, :preload

    def initialize
      @calendar = {
        nation: "japanese",
        language: "en"
      }

      @cache = {
        enable: true,
        max_size: DEFAULT_CACHE_SIZE
      }

      @preload = {
        enable: true, # Require cache enabled
        date_range: 1.year
      }
    end
  end
end
