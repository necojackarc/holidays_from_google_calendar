require "spec_helper"

describe HolidaysFromGoogleCalendar::CacheUnit do
  let(:cache_unit) {
    HolidaysFromGoogleCalendar::CacheUnit.new(holidays, date_min, date_max)
  }
  let(:holidays) { [holiday1, holiday2, holiday3] }
  let(:holiday1) {
    HolidaysFromGoogleCalendar::Holiday.new(
      name: "holiday1",
      date: Date.parse("2016-02-01")
    )
  }
  let(:holiday2) {
    HolidaysFromGoogleCalendar::Holiday.new(
      name: "holiday2",
      date: Date.parse("2016-02-10")
    )
  }
  let(:holiday3) {
    HolidaysFromGoogleCalendar::Holiday.new(
      name: "holiday3",
      date: Date.parse("2016-02-20")
    )
  }
  let(:date_min) { Date.parse("2016-02-01") }
  let(:date_max) { Date.parse("2016-02-29") }

  describe "#include?" do
    subject { cache_unit.include?(other_date_min, other_date_max) }

    context "include other dates" do
      let(:other_date_min) { Date.parse("2016-02-01") }
      let(:other_date_max) { Date.parse("2016-02-20") }
      it { is_expected.to eq true }
    end

    context "not include other dates" do
      let(:other_date_min) { Date.parse("2016-02-01") }
      let(:other_date_max) { Date.parse("2016-03-01") }
      it { is_expected.to eq false }
    end
  end

  describe "#retrieve" do
    subject { cache_unit.retrieve(other_date_min, other_date_max) }

    let(:other_date_min) { Date.parse("2016-02-01") }
    let(:other_date_max) { Date.parse("2016-02-19") }
    it { is_expected.to match [holiday1, holiday2] }
  end

  describe "#overlapped?" do
    subject { cache_unit.overlapped?(other) }

    let(:other) {
      HolidaysFromGoogleCalendar::CacheUnit.new(
        [], other_date_min, other_date_max
      )
    }

    context "subject is earlier than the other" do
      context "subject is a sequence of the other" do
        let(:other_date_min) { Date.parse("2016-03-01") }
        let(:other_date_max) { Date.parse("2016-03-30") }
        it { is_expected.to eq true }
      end

      context "subject is overlapping the other" do
        let(:other_date_min) { Date.parse("2016-02-29") }
        let(:other_date_max) { Date.parse("2016-03-30") }
        it { is_expected.to eq true }
      end

      context "subject is separated form the other" do
        let(:other_date_min) { Date.parse("2016-03-02") }
        let(:other_date_max) { Date.parse("2016-03-30") }
        it { is_expected.to eq false }
      end
    end

    context "subject is later than the other" do
      context "subject is a sequence of the other" do
        let(:other_date_min) { Date.parse("2016-01-01") }
        let(:other_date_max) { Date.parse("2016-01-31") }
        it { is_expected.to eq true }
      end

      context "subject is overlapping the other" do
        let(:other_date_min) { Date.parse("2016-01-01") }
        let(:other_date_max) { Date.parse("2016-02-01") }
        it { is_expected.to eq true }
      end

      context "subject is separated form the other" do
        let(:other_date_min) { Date.parse("2016-01-01") }
        let(:other_date_max) { Date.parse("2016-01-30") }
        it { is_expected.to eq false }
      end
    end
  end

  describe "#conbime" do
    let(:other) {
      HolidaysFromGoogleCalendar::CacheUnit.new(
        other_holidays, other_date_min, other_date_max
      )
    }
    let(:other_holidays) { [other_holiday1, other_holiday2] }
    let(:other_holiday1) {
      HolidaysFromGoogleCalendar::Holiday.new(
        name: "other_holiday1",
        date: Date.parse("2016-03-10")
      )
    }
    let(:other_holiday2) {
      HolidaysFromGoogleCalendar::Holiday.new(
        name: "other_holiday2",
        date: Date.parse("2016-03-20")
      )
    }

    subject { cache_unit.holidays }

    before do
      cache_unit.combine(other)
    end

    context "subject is overlapping the other" do
      let(:other_date_min) { Date.parse("2016-03-01") }
      let(:other_date_max) { Date.parse("2016-03-30") }
      let(:expectation) {
        [holiday1, holiday2, holiday3, other_holiday1, other_holiday2]
      }
      it { is_expected.to match expectation }
    end

    context "subject is not overlapping the other" do
      let(:other_date_min) { Date.parse("2016-03-02") }
      let(:other_date_max) { Date.parse("2016-03-30") }
      let(:expectation) { [holiday1, holiday2, holiday3] }
      it { is_expected.to match expectation }
    end
  end
end
