class ResultsDataController < ApplicationController
  skip_before_action :verify_authenticity_token

  # create index method for testing purpose not need for test task
  def index
    render json: ResultsDatum.all.as_json, status: 200
  end

  def create
    response = ResutDatumArrayInteraction.run!(data: params[:data])
    if response[:success]
      render json: {}, status: 200
    else
      render json: { errors: response[:errors] }.as_json, status: 422
    end
  end
end
