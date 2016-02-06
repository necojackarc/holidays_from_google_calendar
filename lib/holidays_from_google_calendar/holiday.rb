module HolidaysFromGoogleCalendar
  class Holiday
    attr_reader :name, :date

    def initialize(name: nil, date: nil)
      @name = name
      @date = date
    end
  end
end
