class ChangeColTypeToBooleanInUserslogins < ActiveRecord::Migration
  def change 
    add_column :config_tables, :medical_allowance, :decimal
  end
end
