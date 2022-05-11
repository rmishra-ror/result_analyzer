require 'rails_helper'

RSpec.describe 'ResultsData', type: :request do
  describe 'GET /results_data' do
    it 'return 200 status code' do
      get '/results_data'
      expect(response).to have_http_status(200)
    end
  end

  describe 'Post /results_data' do
    it 'creats the data for valid params and return 200 status code' do
      params = {
        data: [{ subject: 'Science', timestamp: '2022-04-18 17:21:55.678', marks: 119.88 }]
      }
      post '/results_data', params: params
      expect(response).to have_http_status(200)
    end
    it 'return 422 status code for invalid params' do
      params = {
        data: [{ subject: 'Science', timestamp: 'wrongtime', marks: 'fake marks' }]
      }
      post '/results_data', params: params
      expect(response).to have_http_status(422)
      expect(response.body).to include('not a valid float')
      expect(response.body).to include('not a valid date time')
    end
  end
end
