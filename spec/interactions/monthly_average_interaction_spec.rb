require 'rails_helper'

RSpec.describe MonthlyAverageInteraction do
  include ActiveSupport::Testing::TimeHelpers

  it 'Should not compute Monthly avaerage if week not contains 3rd wednesday of month' do
    travel_to Time.zone.local(2022, 0o4, 11, 18, 0, 0)
    expect { MonthlyAverageInteraction.run }.not_to change { MonthlyAverage.count }
  end

  it 'Should compute Monthly avaerage if week contains 3rd wednesday of month' do
    travel_to Time.zone.local(2022, 0o4, 18, 18, 0, 0)
    {
      'Science' => [['2022-04-18', 37], ['2022-04-17', 30], ['2022-04-16', 30], ['2022-04-15', 30],
                    ['2022-04-14', 30], ['2022-04-13', 30], ['2022-04-12', 30], ['2022-04-11', 32],
                    ['2022-04-10', 30], ['2022-04-09', 30]],
      'Maths' => [['2022-04-18', 30], ['2022-04-17', 30], ['2022-04-16', 30], ['2022-04-15', 30],
                  ['2022-04-14', 30], ['2022-04-13', 10], ['2022-04-12', 10], ['2022-04-11', 12],
                  ['2022-04-10', 10], ['2022-04-09', 10], ['2022-04-08', 10]],
      'English' => [['2022-04-18', 30], ['2022-04-17', 30], ['2022-04-16', 30], ['2022-04-15', 30],
                    ['2022-04-14', 30], ['2022-04-13', 10], ['2022-04-12', 10], ['2022-04-11', 10],
                    ['2022-04-10', 10], ['2022-04-09', 10], ['2022-04-08', 10]],
      'Hindi' => [['2022-04-18', 60], ['2022-04-17', 60], ['2022-04-16', 40], ['2022-04-15', 30],
                  ['2022-04-14', 10], ['2022-04-13', 10]]
    }.each do |subject, records|
      records.each do |r|
        DailyResultStat.create(subject: subject, daily_low: 50.0, daily_high: 150.0, date: r.first,
                               result_count: r.last)
      end
    end
    expect { MonthlyAverageInteraction.run }.to change { MonthlyAverage.count }.by(4)
    science_avg = MonthlyAverage.where(subject: 'Science').last
    expect(science_avg.monthly_avg_low).to eq(50.0)
    expect(science_avg.monthly_avg_high).to eq(150.0)
    expect(science_avg.monthly_result_count_used).to eq(217)

    maths_avg = MonthlyAverage.where(subject: 'Maths').last
    expect(maths_avg.monthly_avg_low).to eq(50.0)
    expect(maths_avg.monthly_avg_high).to eq(150.0)
    expect(maths_avg.monthly_result_count_used).to eq(202)

    english_avg = MonthlyAverage.where(subject: 'English').last
    expect(english_avg.monthly_avg_low).to eq(50.0)
    expect(english_avg.monthly_avg_high).to eq(150.0)
    expect(english_avg.monthly_result_count_used).to eq(200)

    hindi_avg = MonthlyAverage.where(subject: 'Hindi').last
    expect(hindi_avg.monthly_avg_low).to eq(50.0)
    expect(hindi_avg.monthly_avg_high).to eq(150.0)
    expect(hindi_avg.monthly_result_count_used).to eq(200)
  end
end
