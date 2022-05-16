namespace :batch do
  desc "calclulate Monthly stats"
  task daily_result_stats: :environment do
    DailyResultStatsInteraction.run
  end

  desc "calclulate Monthly stats"
  task mnthly_result_stats: :environment do
    MonthlyAverageInteraction.run
  end
end
