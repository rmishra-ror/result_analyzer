class ResutDatumArrayInteraction < ActiveInteraction::Base
  array :data
  def execute
    result_datums = []
    result_data_errors = []
    @current = nil

    data.as_json.each do |result|
      @current = result
      rd = ResutDatumInteraction.run(result)
      if rd.valid?
        result_datums << rd.result
      else
        result_data_errors << result.merge(errors: rd.errors.messages)
      end
    end

    return { success: false, errors: result_data_errors } if result_data_errors.present?

    ResultsDatum.import!(result_datums) # Bulk importing records
    { success: true }
  rescue StandardError
    { success: false, errors: 'Something went wrong please try agian later' }
  end
end
