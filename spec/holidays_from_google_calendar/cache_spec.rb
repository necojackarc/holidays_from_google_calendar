require "spec_helper"

describe HolidaysFromGoogleCalendar::Cache do
  let(:cache) {
    HolidaysFromGoogleCalendar::Cache.new(enable: true, max_size: max_size)
  }
  let(:max_size) {
    HolidaysFromGoogleCalendar::Configuration::DEFAULT_CACHE_SIZE
  }
  let(:holidays) { [] } # Never care of it in this spec to make testing easy
  let(:date_min) { Date.parse("2016-02-01") }
  let(:date_max) { Date.parse("2016-02-29") }

  before do
    cache.cache(holidays, date_min, date_max)
  end

  subject { cache.size }

  it { is_expected.to eq 1 } # Because `holidays` is empty

  describe "Unite units" do
    let(:new_holidays) { [] }

    before do
      cache.cache(new_holidays, new_date_min, new_date_max)
    end

    context "the new one include the existing one" do
      let(:new_date_min) { Date.parse("2016-01-01") }
      let(:new_date_max) { Date.parse("2016-03-30") }
      it { is_expected.to eq 1 }
    end

    context "the new one is overlapped" do
      let(:new_date_min) { Date.parse("2016-03-01") }
      let(:new_date_max) { Date.parse("2016-03-30") }
      it { is_expected.to eq 1 }
    end

    context "the new one is not overlapped" do
      let(:new_date_min) { Date.parse("2016-03-02") }
      let(:new_date_max) { Date.parse("2016-03-30") }
      it { is_expected.to eq 2 }
    end
  end

  describe "Manage cache size" do
    let(:max_size) { 10 }

    before do
      max_size.times do |i|
        cache.cache(
          [], # holidays
          Date.parse("#{2017 + i}-01-01"),
          Date.parse("#{2017 + i}-01-01")
        )
      end
    end

    context "never exceed the limit" do
      it { is_expected.to eq max_size }
    end

    context "LRU (Least Recently Used)" do
      subject { cache.instance_variable_get("@container").map(&:date_min) }

      before do
        cache.retrieve(Date.parse("2017-01-01"), Date.parse("2017-01-01"))
        cache.cache([], Date.parse("3000-01-01"), Date.parse("3000-01-01"))
      end

      let(:inital_value) {
        max_size.times.map do |i|
          Date.parse("#{2017 + i}-01-01")
        end
      }

      let(:expectation) {
        inital_value
          .reject { |e| e == Date.parse("2018-01-01") }
          .push(Date.parse("3000-01-01"))
      }

      it { is_expected.to contain_exactly(*expectation) }
    end
  end
end
