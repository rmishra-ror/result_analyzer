class MonthlyAverageInteraction < ActiveInteraction::Base
  MIN_AGGREATED_RESULT_COUNT =  200
  RESULT_STATS_DAYS = 5

  def execute
    date = Date.today # To run this function for old date change the date to old value

    # Not do monthly calulation if week not contains 3rd wednesday
    return unless Utility.week_contains_3rd_wednesday?(date)

    subject_with_date_and_count = min_aggregated_date_subject_wise(date)
    return unless subject_with_date_and_count.present?

    subject_with_date_and_count.group_by { |r| r[:date] }.each do |date_key, value|
      compute_montly_average(value.map { |r| r[:subject] }, date_key, value, date)
    end
  end

  def compute_montly_average(subjects, date, records, end_date)
    DailyResultStat.where('date >= ? and date <= ?', date, end_date)
                   .where(subject: subjects)
                   .select("subject,\
                    AVG('daily_result_stats'.'daily_low') as low_avg,\
                    AVG('daily_result_stats'.'daily_high') as high_avg")
                   .group(:subject).each do |obj|
      subject_count = records.detect { |r| r[:subject] == obj.subject }[:count]
      MonthlyAverage.create(subject: obj.subject,
                            date: end_date,
                            monthly_avg_low: obj.low_avg,
                            monthly_avg_high: obj.high_avg,
                            monthly_result_count_used: subject_count)
    end
  end

  def min_aggregated_date_subject_wise(start_date)
    end_date = (start_date - RESULT_STATS_DAYS)
    subject_wise_result_count = DailyResultStat.where('date >= ? and date <= ?', end_date, start_date)
                                               .group(:subject).sum(:result_count)
    subject_with_min_avg_count = subject_wise_result_count.select { |_s, v| v >= MIN_AGGREATED_RESULT_COUNT }

    subjects = subject_with_min_avg_count.collect do |subject, value|
      { subject: subject, date: start_date, count: value }
    end
    # filter out subjects for which count < MIN_AGGREATED_RESULT_COUNT in last N days
    subject_list = subject_wise_result_count.collect { |s, v| s if v < MIN_AGGREATED_RESULT_COUNT }.compact
    return subjects if subject_list.blank?

    DailyResultStat.where('date >= ? and date <= ?', start_date.beginning_of_month, start_date)
                   .where(subject: subject_list)
                   .select(:result_count, :subject, :date)
                   .group_by(&:subject).each do |subject, records|
      sum = 0
      record = records.sort_by(&:date).reverse.detect do |r|
        sum += r.result_count
        sum >= MIN_AGGREATED_RESULT_COUNT
      end
      subjects << { subject: subject, date: record.date, count: sum }
    end
    subjects
  end
end
