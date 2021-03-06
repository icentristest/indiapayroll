module ApplicationHelper
  
  def current_period_info
    current_period
    pay_details=Hash.new
    pay_details[:current_month]  ="April May June July August September October \
    November December January February March " .split(" ")[@period_id[0..@period_id.length-7].to_i-1]
    pay_details[:current_fyear] = @current_fyear
    pay_details[:period_id]=@period_id
    pay_details
  end
 
  def current_period
    starting_period_id="1"+"#{Time.now.year}"+"#{(Time.now.year+1).to_s[2..4]}"
    payperiod_details=PayPeriod.find_by_period_id(starting_period_id)
    prepare_fyear="#{Time.now.year}#{(Time.now.year+1).to_s[2..4]}"
    @current_fyear=payperiod_details.current_fyear
    #@current_fyear="#{Time.now.year}-""#{(Time.now.year+1).to_s[2..4]}"
    if PaymentHistory.find_by_period_id(starting_period_id).nil?
      @period_id=starting_period_id
    else
      last_record=PaymentHistory.last.period_id
      unless PaymentHistory.last.period_id[0..last_record.length-7].to_i+1 > 12
        period_month=PaymentHistory.last.period_id[0..last_record.length-7].to_i+1
      else
        period_month =1
        current_year=PayPeriod.find_by_period_id(last_record).current_fyear
        fyear=current_year[0..3].to_i + 1
        lyear =current_year[5..7].to_i + 1
        prepare_fyear="#{fyear}#{lyear}"
      end 
      @period_id="#{period_month}#{prepare_fyear}"
      payperiod_details=PayPeriod.find_by_period_id(@period_id)
      @current_fyear=payperiod_details.current_fyear
      #@current_fyear="#{Time.now.year}-""#{(Time.now.year+1).to_s[2..4]}"
    end
  end
end
