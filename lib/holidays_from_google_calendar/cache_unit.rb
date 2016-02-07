module HolidaysFromGoogleCalendar
  class CacheUnit
    attr_reader :holidays, :date_min, :date_max

    def initialize(holidays, date_min, date_max)
      @holidays = holidays
      @date_min = date_min
      @date_max = date_max
    end

    def size
      @holidays.size
    end

    def include?(date_min, date_max)
      [date_min, date_max].all? { |e| @date_min <= e && e <= @date_max }
    end

    def retrieve(date_min, date_max)
      @holidays.select { |e| date_min <= e.date && e.date <= date_max }
    end

    def overlapped?(other)
      (date_min <= other.date_max && other.date_min <= date_max + 1.day) ||
        (other.date_min <= date_max && date_min <= other.date_max + 1.day)
    end

    def combine(other)
      return unless overlapped?(other)
      @date_min = [@date_min, other.date_min].min
      @date_max = [@date_max, other.date_max].max
      @holidays =
        @holidays.concat(other.holidays).uniq.sort { |a, b| a.date <=> b.date }
    end
  end
end
