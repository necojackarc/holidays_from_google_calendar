$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"

SimpleCov.start

require "rspec/its"
require "holidays_from_google_calendar"
