module HolidaysFromGoogleCalendar
  class Cache
    def initialize(enable: nil, size: nil)
      @enable = enable
      @size = size
      @container = []
    end

    def enabled?
      @enable
    end

    def cache(holidays, date_min, date_max)
      pack_container(CacheUnit.new(holidays, date_min, date_max))
    end

    def retrieve(date_min, date_max)
      @container.each do |unit|
        next unless unit.include?(date_min, date_max)
        return unit.retrieve(date_min, date_max)
      end
      nil # Haven't hit any cache
    end

    private

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
  end
end
