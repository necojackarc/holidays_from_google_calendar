module HolidaysFromGoogleCalendar
  class CacheUnit
    attr_reader :holidays, :date_min, :date_max

    def initialize(holidays, date_min, date_max)
      @holidays = holidays
      @date_min = date_min
      @date_max = date_max
    end

    def include?(date_min, date_max)
      [date_min, date_max].all? { |e| @date_min <= e && e <= @date_max }
    end

    def retrieve(date_min, date_max)
      @holidays.select { |e| date_min <= e.date && e.date <= date_max }
    end

    def overlapped?(other)
      (date_min <= other.date_max && other.date_min <= date_max) ||
        (other.date_min <= date_max && date_min <= other.date_max)
    end

    def combine(other)
      return unless overlapped?(other)

      if date_min <= other.date_max
        date_min = other.date_min # rubocop:disable Lint/UselessAssignment
      elsif other.date_min <= date_max
        date_max = other.date_max # rubocop:disable Lint/UselessAssignment
      end
      @holidays =
        @holidays.concat(other.holidays).uniq.sort { |a, b| a.date <=> b.date }
    end
  end
end
