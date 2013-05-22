class PayPeriod < ActiveRecord::Base
  attr_accessible :end_date, :period_id, :period_type, :start_date ,:current_fyear ,:status
end
