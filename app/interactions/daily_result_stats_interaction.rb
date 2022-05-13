class DailyResultStatsInteraction < ActiveInteraction::Base
  def execute
    start_time = Date.today
    start_time = start_time.beginning_of_day
    end_time = start_time.end_of_day
    daily_results = ResultsDatum.where(timestamp: start_time..end_time).select(:marks, :subject)
                                .group_by(&:subject)
    daily_results.each do |subject, results|
      result_count = results.count
      marks = results.map(&:marks)
      daily_low = marks.min
      daily_high = marks.max
      DailyResultStat.create(
        subject: subject,
        date: start_time.to_date,
        result_count: result_count,
        daily_low: daily_low,
        daily_high: daily_high
      )
    end
  end
end
