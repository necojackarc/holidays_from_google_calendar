module HolidaysFromGoogleCalendar
  class Configuration
    ATTRIBUTES = %i(nation language api_key)

    attr_accessor(*ATTRIBUTES)

    def to_h
      ATTRIBUTES.reduce({}) do |hash, attribute|
        hash.merge(attribute => public_send(attribute))
      end
    end
  end
end
