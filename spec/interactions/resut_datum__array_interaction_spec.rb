require 'rails_helper'

RSpec.describe ResutDatumArrayInteraction do
  let(:params) { {} }
  let(:outcome) { described_class.run(params) }
  let(:outcome!) { described_class.run!(params) }

  it 'type checks' do
    expect(outcome).to_not be_valid
    expect(outcome.errors).to have_key :data
    expect(outcome.errors[:data]).to include 'is required'
  end

  it 'type checks!' do
    expect { outcome! }.to raise_error ActiveInteraction::InvalidInteractionError
  end

  it 'type checks presence of data params[:subject, timestamp, :timestamp]' do
    params[:data] = [{}]
    expect(outcome.result[:success]).to be false
    errors = outcome.result[:errors].first[:errors]
    expect(errors[:subject]).to include 'is required'
    expect(errors[:timestamp]).to include 'is required'
    expect(errors[:timestamp]).to include 'is required'
  end

  it 'type checks data params[:subject, timestamp, :timestamp]' do
    params[:data] = [{ subject: 'Science', timestamp: 'fake', marks: 'wrong' }]
    expect(outcome.result[:success]).to be false
    errors = outcome.result[:errors].first[:errors]
    expect(errors[:timestamp]).to include 'is not a valid date time'
    expect(errors[:marks]).to include 'is not a valid float'
  end
  it 'gracefully handle exception' do
    allow(ResutDatumInteraction).to receive(:run).and_raise(ActiveRecord::StaleObjectError)
    params[:data] = [{}]
    expect(outcome.result[:success]).to be false
    expect(outcome.result[:errors]).to include 'Something went wrong please try agian later'
  end

  it 'executes successfully for valid params and create data' do
    params[:data] = [{ subject: 'Science', timestamp: '2022-04-18 17:21:55.678', marks: 119.88 }]
    expect { outcome }.to change { ResultsDatum.count }.by(1)
    expect(outcome).to be_valid
    expect(outcome.result[:success]).to be true
  end

  it 'executes successfully for multiple valid params and create data' do
    params[:data] = [
      { subject: 'Science', timestamp: '2022-04-18 17:21:55.678', marks: 119.88 },
      { subject: 'Science', timestamp: '2022-04-18 16:21:55.678', marks: 109.88 }
    ]
    expect { outcome }.to change { ResultsDatum.count }.by(2)
    expect(outcome).to be_valid
    expect(outcome.result[:success]).to be true
  end
end
