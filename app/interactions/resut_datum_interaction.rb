class ResutDatumInteraction < ActiveInteraction::Base
  string :subject
  date_time :timestamp
  float :marks, presence: true
  validates :subject, presence: true

  def execute
    ResultsDatum.new(subject: subject, timestamp: timestamp, marks: marks, created_at: Time.now, updated_at: Time.now)
  end
end
