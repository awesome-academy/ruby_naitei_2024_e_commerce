class AddCancellationReasonToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :cancellation_reason, :integer
  end
end
