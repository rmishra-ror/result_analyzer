class ResultsDatum < ApplicationRecord
  validates_presence_of :subject, :timestamp, :marks
end
