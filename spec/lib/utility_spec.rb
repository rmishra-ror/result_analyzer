require 'rails_helper'
RSpec.describe Utility do
  it 'return 3rd wendnesday of month' do
    date = Date.parse('18/04/2022')
    expect(Utility.third_wednesday_of_month(date)).to eq(Date.parse('20/04/2022'))
  end

  it 'return true if current date is monday and week contains 3rd wednesday' do
    date = Date.parse('18/04/2022')
    expect(Utility.week_contains_3rd_wednesday?(date)).to eq true
  end
end
