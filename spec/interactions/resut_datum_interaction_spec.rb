require 'rails_helper'

RSpec.describe ResutDatumInteraction do
  let(:params) { {} }
  let(:outcome) { described_class.run(params) }
  let(:outcome!) { described_class.run!(params) }

  it 'type checks' do
    expect(outcome).to_not be_valid
    expect(outcome.errors).to have_key :subject
    expect(outcome.errors).to have_key :timestamp
    expect(outcome.errors).to have_key :marks
    expect(outcome.errors[:subject]).to include 'is required'
    expect(outcome.errors[:timestamp]).to include 'is required'
    expect(outcome.errors[:marks]).to include 'is required'
  end

  it 'type checks!' do
    expect { outcome! }.to raise_error ActiveInteraction::InvalidInteractionError
  end

  it 'type checks data params[:subject, timestamp, :timestamp]' do
    params = { subject: 'Science', timestamp: 'fake', marks: 'wrong' }
    outcome = ResutDatumInteraction.run(params)
    expect(outcome).to_not be_valid
    expect(outcome.errors[:timestamp]).to include 'is not a valid date time'
    expect(outcome.errors[:marks]).to include 'is not a valid float'
  end

  it 'executes successfully for valid params and return ResultsDatum object' do
    params = { subject: 'Science', timestamp: '2022-04-18 17:21:55.678', marks: 119.88 }
    outcome = ResutDatumInteraction.run(params)
    expect(outcome).to be_valid
  end
end
