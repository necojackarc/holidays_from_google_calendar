$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"
require "codeclimate-test-reporter"

SimpleCov.start
CodeClimate::TestReporter.start

require "holidays_from_google_calendar"
