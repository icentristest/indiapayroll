class AddMedicalAllowanceToConfigTable < ActiveRecord::Migration
  def change
    add_column :pay_periods, :status, :boolean
  end
end
