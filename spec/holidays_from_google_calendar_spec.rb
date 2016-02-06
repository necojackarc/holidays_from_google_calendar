require "spec_helper"

describe HolidaysFromGoogleCalendar do
  it "has a version number" do
    expect(HolidaysFromGoogleCalendar::VERSION).not_to be nil
  end

  let(:holidays) { HolidaysFromGoogleCalendar::Holidays.new(&config) }
  let(:config) {
    -> (config) {
      config.calendar = { nation: nation, language: language }
      config.credential = { api_key: api_key }
    }
  }
  let(:api_key) { ENV["GOOGLE_API_KEY"] }
  let(:date) { Date.current.beginning_of_year.next_month } # 1st Feburary

  subject { holidays }

  describe "#in_year" do
    let(:config) { -> (config) { config.credential = { api_key: api_key } } }

    describe "response format" do
      subject { holidays.in_year(date).first }
      its(:name) { is_expected.to be_a String  }
      its(:date) { is_expected.to be_a Date }
    end
  end

  describe "#in_month" do
    let(:config) { -> (config) { config.credential = { api_key: api_key } } }

    describe "response format" do
      subject { holidays.in_month(date).first }
      its(:name) { is_expected.to be_a String  }
      its(:date) { is_expected.to be_a Date }
    end
  end

  context "US holidays in English" do
    let(:nation) { "usa" }
    let(:language) { "en" }

    let(:valentines_day) { "Valentine's Day" }
    let(:christmas_eve) { "Christmas Eve" }

    describe "#in_year" do
      subject { holidays.in_year(date).map(&:name) }

      it { is_expected.to include valentines_day }
      it { is_expected.to include christmas_eve }
    end

    describe "#in_month" do
      subject { holidays.in_month(date).map(&:name) }

      it { is_expected.to include valentines_day }
      it { is_expected.not_to include christmas_eve }
    end

    describe "#holiday?" do
      subject { holidays.holiday?(date) }

      context "Valentine's day is one of US's holidays" do
        let(:date) { Date.current.beginning_of_year.next_month.in(13.days) }
        it { is_expected.to eq true }
      end
    end
  end

  context "Japanese holidays in English" do
    let(:nation) { "japanese" }
    let(:language) { "en" }

    let(:national_foundation_day) { "National Foundation Day" }
    let(:greenery_day) { "Greenery Day" }

    describe "#in_year" do
      subject { holidays.in_year(date).map(&:name) }

      it { is_expected.to include national_foundation_day }
      it { is_expected.to include greenery_day }
    end

    describe "#in_month" do
      subject { holidays.in_month(date).map(&:name) }

      it { is_expected.to include national_foundation_day }
      it { is_expected.not_to include greenery_day }
    end

    describe "#holiday?" do
      subject { holidays.holiday?(date) }

      context "National Foundation Day is one of Japanese holidays" do
        let(:date) { Date.current.beginning_of_year.next_month.in(10.days) }
        it { is_expected.to eq true }
      end
    end
  end
end
