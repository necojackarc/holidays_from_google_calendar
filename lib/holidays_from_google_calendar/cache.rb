module HolidaysFromGoogleCalendar
  class Cache
    attr_reader :size

    def initialize(enable: nil, max_size: nil)
      @enable = enable
      @max_size = max_size
      @container = []
      calculate_size
    end

    def enabled?
      @enable
    end

    def cache(holidays, date_min, date_max)
      pack_container(CacheUnit.new(holidays.dup, date_min, date_max))
      page_out if calculate_size > @max_size
    end

    def retrieve(date_min, date_max)
      unit = @container.find { |e| e.include?(date_min, date_max) }
      return nil if unit.nil?

      # For LRU (Least Recently Used)
      @container.delete(unit)
      @container.push(unit)

      unit.retrieve(date_min, date_max)
    end

    private

    # The size of cache is sum of unit count and the number of holidays
    def calculate_size
      @size = unit_count + holidays_count
    end

    def unit_count
      @container.size
    end

    def holidays_count
      @container.map(&:size).sum
    end

    def pack_container(new_unit)
      unnecessary_units = @container.reduce([]) do |array, unit|
        # If there are overlapped units, combine them into the new unit
        if new_unit.include?(unit.date_min, unit.date_max)
          array.push(unit)
        elsif new_unit.overlapped?(unit)
          new_unit.combine(unit)
          array.push(unit)
        else
          array # Do nothing
        end
      end
      @container -= unnecessary_units
      @container.push(new_unit)
    end

    def page_out
      deleted_size = 0
      while (@size - deleted_size) > @max_size
        unit = @container.shift
        deleted_size += (1 + unit.size) # Size is unit count plus holiday count
      end
      @size -= deleted_size
    end
  end
end
