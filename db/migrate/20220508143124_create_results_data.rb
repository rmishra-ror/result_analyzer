class CreateResultsData < ActiveRecord::Migration[6.1]
  def change
    create_table :results_data do |t|
      t.string :subject
      t.datetime :timestamp
      t.float :marks
      t.timestamps
    end
  end
end
