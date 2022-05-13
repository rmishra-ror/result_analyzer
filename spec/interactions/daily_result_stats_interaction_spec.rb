require 'rails_helper'

RSpec.describe DailyResultStatsInteraction do
  include ActiveSupport::Testing::TimeHelpers

  before(:each) do
    timestamp = DateTime.parse('18/04/2022 5:5:5')
    ResultsDatum.create(subject: 'Science', timestamp: timestamp, marks: 100.5)
    ResultsDatum.create(subject: 'Science', timestamp: timestamp, marks: 174.5)
    ResultsDatum.create(subject: 'Science', timestamp: timestamp, marks: 25)
    ResultsDatum.create(subject: 'Maths', timestamp: timestamp, marks: 150)
    ResultsDatum.create(subject: 'Maths', timestamp: timestamp, marks: 100)
    ResultsDatum.create(subject: 'Maths', timestamp: timestamp, marks: 110)
  end

  it 'computs and store daily results stats' do
    travel_to Time.zone.local(2022, 0o4, 18, 18, 0, 0)
    expect(DailyResultStat.count).to eq(0)
    DailyResultStatsInteraction.run
    expect(DailyResultStat.count).to eq(2)

    daily_stat_science = DailyResultStat.where(subject: 'Science').first
    daily_stat_maths = DailyResultStat.where(subject: 'Maths').first
    expect(daily_stat_science.result_count).to eq(3)
    expect(daily_stat_science.daily_low).to eq(25)
    expect(daily_stat_science.daily_high).to eq(174.5)

    expect(daily_stat_maths.result_count).to eq(3)
    expect(daily_stat_maths.daily_low).to eq(100)
    expect(daily_stat_maths.daily_high).to eq(150)
  end
end
