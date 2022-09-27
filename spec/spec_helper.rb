$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"

SimpleCov.start do
  if ENV["CI"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

require "rspec/its"
require "holidays_from_google_calendar"
