class MonthlyAverage < ApplicationRecord
  validates :subject, uniqueness: { scope: :date }
end
