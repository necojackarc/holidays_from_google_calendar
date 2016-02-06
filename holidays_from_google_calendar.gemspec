# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'holidays_from_google_calendar/version'

Gem::Specification.new do |spec|
  spec.name          = "holidays_from_google_calendar"
  spec.version       = HolidaysFromGoogleCalendar::VERSION
  spec.authors       = ["necojackarc"]
  spec.email         = ["necojackarc@gmail.com"]

  spec.summary       = %q{Holidays from Google Calendar.}
  spec.description   = %q{Retriving national holidays from Google Calendar.}
  spec.homepage      = "https://github.com/necojackarc/holidays_from_google_calendar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
