require 'rails_helper'

RSpec.describe MonthlyAverageInteraction do
  include ActiveSupport::Testing::TimeHelpers

  it 'Should not comput Monthly avaerage if week not contains 3rd wednesday of month' do
    travel_to Time.zone.local(2022, 0o4, 11, 18, 0, 0)
    MonthlyAverageInteraction.run
  end
end
