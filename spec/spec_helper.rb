$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "codeclimate-test-reporter"
require "simplecov"

SimpleCov.start
CodeClimate::TestReporter.start

require "rspec/its"
require "holidays_from_google_calendar"
