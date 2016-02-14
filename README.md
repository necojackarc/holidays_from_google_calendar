# HolidaysFromGoogleCalendar [![Build Status](https://travis-ci.org/necojackarc/holidays_from_google_calendar.svg?branch=master)](https://travis-ci.org/necojackarc/holidays_from_google_calendar) [![Code Climate](https://codeclimate.com/github/necojackarc/holidays_from_google_calendar/badges/gpa.svg)](https://codeclimate.com/github/necojackarc/holidays_from_google_calendar) [![Test Coverage](https://codeclimate.com/github/necojackarc/holidays_from_google_calendar/badges/coverage.svg)](https://codeclimate.com/github/necojackarc/holidays_from_google_calendar/coverage)
HolidaysFromGoogleCalendar can retrieve national holidays from Google Calendar with very simple interface.

The results is going to be cached and you can preload holidays with your favorite range at initialization if you want.
These features help you to reduce access times to Google Calendar API.

I am sure that you only need to access the API a very few times if you preload holidays with proper range.

Using Google Calendar, available nations are same as Google Calendar.

Note that you can only retrieve holidays which Google Calendar has.
Google Calendar appears not to have all holidays, so you cannot retrieve very old ones and far future's.

## Features
### Main
* List holidays of a particular nation in a particular year
* List holidays of a particular nation in a particular month
* Check a date whether it is a holiday or not in a particular nation

### Others
* Cacheing results using LRU algorithm
* Preload holidays at initialization

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'holidays_from_google_calendar'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install holidays_from_google_calendar
```

## Usage
### Configuration
All parameters you can pass are below:

```ruby
usa_holidays = HolidaysFromGoogleCalendar::Holidays.new do |config|
  config.credential = {
    api_key: "YOUR OWN GOOGLE API KEY"
  }

  config.calendar = {
    nation: "usa",
    language: "en"
  }

  config.cache = {
    enable: true,
    max_size: 1000 # DEFAULT_CACHE_SIZE is 1000
  }

  config.preload = {
    enable: true, # Require cache enabled
    date_range: 1.year # Retrive holidays from "this day last year" to "this day next year"
  }
end
```

Default parameters of `cache` and `preload` are same as above.

### List holidays of a particular nation in a particular year
Returns a array of holidays in a particular year.

```ruby
usa_holidays.in_year(Date.current)
```

### List holidays of a particular nation in a particular month
Returns a array of holidays in a particular month.

```ruby
usa_holidays.in_month(Date.current)
```

### Check a date whether it is a holiday or not in a particular nation
Returns `true` when the day is holiday, Saturday or Sunday.

```ruby
usa_holidays.holiday?(Date.current)
```

### Sample code
```ruby
require "holidays_from_google_calendar"

usa_holidays = HolidaysFromGoogleCalendar::Holidays.new do |config|
  config.calendar = {
    nation: "usa",
    language: "en"
  }

  config.credential = {
    api_key: "YOUR OWN GOOGLE API KEY"
  }
end

usa_holidays.in_year(Date.parse("2016-02-06")) # Retrieve 2016's holidays
=> [#<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42df748 @date=Fri, 01 Jan 2016, @name="New Year's Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42def28 @date=Mon, 18 Jan 2016, @name="Martin Luther King Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42de820 @date=Sun, 14 Feb 2016, @name="Valentine's Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42de0f0 @date=Mon, 15 Feb 2016, @name="Presidents' Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42dd808 @date=Sun, 13 Mar 2016, @name="Daylight Saving Time starts">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42dc8e0 @date=Sun, 27 Mar 2016, @name="Easter Sunday">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab3b40 @date=Wed, 13 Apr 2016, @name="Thomas Jefferson's Birthday">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab36b8 @date=Sun, 08 May 2016, @name="Mother's Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab3230 @date=Mon, 30 May 2016, @name="Memorial Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab2d08 @date=Sun, 19 Jun 2016, @name="Father's Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab26a0 @date=Mon, 04 Jul 2016, @name="Independence Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab21a0 @date=Mon, 05 Sep 2016, @name="Labor Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab1cc8 @date=Mon, 10 Oct 2016, @name="Columbus Day (regional holiday)">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab1610 @date=Mon, 31 Oct 2016, @name="Halloween">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab0f30 @date=Sun, 06 Nov 2016, @name="Daylight Saving Time ends">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab0a58 @date=Tue, 08 Nov 2016, @name="Election Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab0648 @date=Fri, 11 Nov 2016, @name="Veterans Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d4ab0238 @date=Thu, 24 Nov 2016, @name="Thanksgiving Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42d7f20 @date=Sat, 24 Dec 2016, @name="Christmas Eve">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42d7a70 @date=Sun, 25 Dec 2016, @name="Christmas Day">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42d7660 @date=Mon, 26 Dec 2016, @name="Christmas Day observed">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42d70e8 @date=Sat, 31 Dec 2016, @name="New Year's Eve">,

usa_holidays.in_month(Date.parse("3rd March 2016")) # Retrieve holidays of March, 2016
=> [#<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42dd808 @date=Sun, 13 Mar 2016, @name="Daylight Saving Time starts">,
 #<HolidaysFromGoogleCalendar::Holiday:0x007ff7d42dc8e0 @date=Sun, 27 Mar 2016, @name="Easter Sunday">]

usa_holidays.holiday?(Date.parse("Oct 31 2016")) # Halloween
=> true

usa_holidays.holiday?(Date.parse("April 16th 2016")) # Saturday
=> true

usa_holidays.holiday?(Date.parse("April 17th 2016")) # Sunday
=> true

usa_holidays.holiday?(Date.parse("Aug 2 2016")) # Weekday (Tuesday)
=> false
```

## Development
Need to set the following environment variable to run rspec:

```bash
GOOGLE_API_KEY="YOUR OWN GOOGLE API KEY"
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/holidays_from_google_calendar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
