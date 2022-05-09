class CreateMonthlyAverages < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_averages do |t|
      t.date :date
      t.string :subject
      t.float :monthly_avg_low
      t.float :monthly_avg_high
      t.integer :monthly_result_count_used
      t.timestamps
    end
  end
end
