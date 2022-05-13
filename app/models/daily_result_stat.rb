class DailyResultStat < ApplicationRecord
  validates :subject, uniqueness: { scope: :date }
end
