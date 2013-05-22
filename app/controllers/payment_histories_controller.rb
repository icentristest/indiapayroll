class PaymentHistoriesController < ApplicationController
  include PaymentHistoriesHelper
  # GET /payment_histories
  # GET /payment_histories.json
  #before_filter :deny_payroll ,:only =>[:monthly_salaries] 
  def index
    @payment_histories = PaymentHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @payment_histories }
    end
  end

  # GET /payment_histories/1
  # GET /payment_histories/1.json
  def show
    @payment_history = PaymentHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payment_history }
    end
  end

  # GET /payment_histories/new
  # GET /payment_histories/new.json
  def new
    @payment_history = PaymentHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payment_history }
    end
  end

  # GET /payment_histories/1/edit
  def edit
    @payment_history = PaymentHistory.find(params[:id])
  end

  # POST /payment_histories
  # POST /payment_histories.json
  def create
    @payment_history = PaymentHistory.new(params[:payment_history])

    respond_to do |format|
      if @payment_history.save
        format.html { redirect_to @payment_history, :notice => 'Payment history was successfully created.' }
        format.json { render :json => @payment_history, :status => :created, :location => @payment_history }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payment_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payment_histories/1
  # PUT /payment_histories/1.json
  def update
    @payment_history = PaymentHistory.find(params[:id])

    respond_to do |format|
      if @payment_history.update_attributes(params[:payment_history])
        format.html { redirect_to @payment_history, :notice => 'Payment history was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payment_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_histories/1
  # DELETE /payment_histories/1.json
  def destroy
    @payment_history = PaymentHistory.find(params[:id])
    @payment_history.destroy

    respond_to do |format|
      format.html { redirect_to payment_histories_url }
      format.json { head :no_content }
    end
  end
  
  def current_period_info
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
  
  def load_payment
    @salary_info=Hash.new
    @payload_hash = Hash.new
    current_period_info
    employees =Employee.all
    unless employees.empty?
    employees.each do |employee|
    @salary_info[employee.emp_id]= params[:monthlysal][:"#{employee.emp_id}_net"]
    end
    end
    d1 = Date.today
    d2 = Date.new(@current_fyear[0,4].to_i+1,03,30)
    months = (d2.year*12+d2.month) - (d1.year*12+d1.month)
      @config_info = ConfigTable.where("year" => @current_fyear).first
      @basic_percent = @config_info.basic_percent
      hra_percent = @config_info.hra_percent
      p_tax = @config_info.professional_tax
      conveyance = @config_info.conveyance
      edu_cess_percent = @config_info.edu_cess
      medical_allowance = @config_info.medical_allowance
      
      @salary_info.each do |key, value|
      emp_id = key
      @net_pay = params[:monthlysal][:"#{emp_id}_net"].to_i
      gross_ctc = params[:monthlysal][:"#{emp_id}_gross"].to_i
      loss_of_hours = params[:monthlysal][:"#{emp_id}_sick"].to_i
      tds = calculate_tds(emp_id)
      if tds > 0
      tds_per_month = tds/12
      else
      tds_per_month = 0
      end
      @payment_history = PaymentHistory.new(params[:payment_history])
      @payment_history.emp_id = emp_id
      employee =Employee.find_by_emp_id(emp_id)
      @payment_history.full_name=employee.first_name + " " +employee.last_name
      calculatehra(emp_id,gross_ctc)
      basic_per_year = (@basic_percent * gross_ctc)/100
      basic_per_month = basic_per_year/12
      hra_per_year = (hra_percent * basic_per_year)/100
      @payment_history.hra =  hra_per_year/12
      @payment_history.basic = basic_per_month
      @payment_history.tds = tds_per_month
      @payment_history.period_id = @period_id
      @payment_history.conveyance = conveyance/12
      @payment_history.professional_tax = p_tax/12
      @payment_history.loss_of_hours = loss_of_hours
      @payment_history.gross_monthly=@net_pay
      @payment_history.medical_allowance = medical_allowance/12
      sum_allowances = 0
      allowance_components = [basic_per_year,medical_allowance,hra_per_year,conveyance]
      sum_allowances = allowance_components.inject{|sum_allowances,x| sum_allowances + x }
      @payment_history.special_allowance = (gross_ctc - sum_allowances)/12 
      calculate_gross(emp_id ,gross_ctc,@net_pay)
      taxble_income = calculate_gross(emp_id ,gross_ctc,@net_pay) - (@tds.to_i + p_tax)
      puts "*********************************************************************taxble income"
      puts "gross #{gross_ctc}"
      puts "prof tax #{p_tax}"
      puts "tds from emp #{@tds.to_i}"
      
      @t_s = calculate_tax(taxble_income)
      puts "income tax #{@t_s}"
      puts "education cess #{edu_cess_percent}"
      deducte_tax =PaymentHistory.where(:emp_id=>emp_id).sum(:tax_deducted)
      
      final_tax_amount = @t_s.to_i + (edu_cess_percent* @t_s.to_i)/100 - deducte_tax
      remaining_months =13 - @period_id[0..@period_id.length-7].to_i
      
       
      puts "tax deducted #{PaymentHistory.where(:emp_id=>emp_id).sum(:tax_deducted)}"
      puts "deductions edu #{(edu_cess_percent/100) * @t_s.to_i}"
      puts "final tax amount #{final_tax_amount}"
      puts "#{remaining_months}"
      monthly_tax = 0
      if final_tax_amount > 0
      monthly_tax = final_tax_amount/remaining_months
      else
        final_tax_amount = 0
      end
      @payment_history.tax_deducted = monthly_tax
      @payment_history.net_monthly = (gross_ctc.to_i)/12 - monthly_tax
      
      @payload_hash[emp_id]= @payment_history
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @payment_histories }
      end
      @payload_hash
  end  
  
  def calculatehra(emp_id,gross_ctc) 
    current_period_info
    config_info = ConfigTable.where("year" => @current_fyear).first
    @emp_declaration = EmpDeclaration.where("emp_id" => emp_id).order(:updated_at).reverse_order.first
    if @emp_declaration.nil? 
    @hra_per_year = 0
    @hra_per_month = 0
    else
    total_hra = @emp_declaration.rent_receipts_total
    basic = config_info.basic_percent
    hra = config_info.hra_percent
    basic_sal_per_year = (gross_ctc*basic)/100
    hra_cal1_per_year =  total_hra-(basic_sal_per_year*0.1)
    hra_cal2_per_year =  (0.4*basic_sal_per_year)
    @hra_per_year = [hra_cal1_per_year,hra_cal2_per_year,total_hra].min
    puts "hra per year #{@hra_per_year}"
    end  
  end
  

  def calculate_tax(net)
   @s =  TaxSlab.where("year" => @current_fyear)
   t = net
     @s.each do |slab|
        if t.to_i >= slab.slab_from.to_i &&  t.to_i < slab.slab_to.to_i
        percentage = slab.deduction_percent
        min_amount = slab.min_tax
        extra_amount = t.to_i - slab.slab_from.to_i
        puts "tabxble income #{t.to_i}"
        puts "slab from #{slab.slab_from.to_i}"
        
        puts "extra  amount#{extra_amount}"
        puts "ldjasljdkls"
        @tax_slab = ((extra_amount/100)*percentage.to_i)+min_amount.to_i 
        end
     end
     @tax_slab
  end
      
  def calculate_tds(emp_id)
    @emp_id =  emp_id
    @emp_declaration = EmpDeclaration.where("emp_id" => @emp_id).order(:updated_at).reverse_order.first
    if @emp_declaration.nil?
    @tds = 0
    @tds_per_month=0
    else
    @section1 = @emp_declaration.total_hra
    @config_info = ConfigTable.where("year" => @current_fyear).first
    section3 = @config_info.conveyance
    section7 = @config_info.medical_allowance
    section2 = [@emp_declaration.medical_receipts,@config_info.medical_receipts_limit].min
    sum_section4 = 0
    sum_section5 = 0
    section4_components = [@emp_declaration.insurance_80c,@emp_declaration.ppf_80c,
                          @emp_declaration.mf_80c,@emp_declaration.hloan_principal_80c,
                          @emp_declaration.children_fee_80c,@emp_declaration.nsc_80c]                    
    sum_section4 = section4_components.inject{|sum_section4,x| sum_section4 + x }
    section4 = [sum_section4,@config_info.limit_80c].min  
    section5_components = [ @emp_declaration.donations_80g,@emp_declaration.med_insurance_80d,@emp_declaration.interest_EduLoan_80e]
    sum_section5 = section5_components.inject{|sum_section5,x| sum_section5 + x }
    @house_self_occupied_flag = @emp_declaration.house_self_occupied
    hra_applicable = @emp_declaration.hra_status
    interest_on_hloan =0
    if (@house_self_occupied_flag == 'yes' && hra_applicable == 'no') 
      interest_on_hloan = @emp_declaration.home_loan_interest
     elsif (@house_self_occupied_flag == 'no' && hra_applicable == 'yes')
      interest_on_hloan = [@emp_declaration.home_loan_interest,@config_info.h_loan_limit].min
     else
    end
  section6 = interest_on_hloan
  puts "sections start"
  puts "section1 #{@section1}"
  puts "section2 #{section2}"
  puts "section3 #{section3}"
  puts "section4 #{section4}"
  puts "section5 #{sum_section5}"
  puts "section6 #{section6}"
  puts "section7 #{section7}"
  puts "section end"
  
  @tds = [@section1,section2,section3,section4,sum_section5,section6].sum
  end
  end
  
  
  def monthly_salaries
    @employees = Employee.where(:status=>true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=> @employees }
  end
  end
  
  def save_payment
    current_period_info
    employees =Employee.all
    unless employees.empty?
    employees.each do |employee|
      payment_history = PaymentHistory.new()
      payment_history.emp_id = employee.emp_id
      payment_history.period_id = @period_id 
      pay=PayPeriod.where("period_id = ?" ,@period_id)
      payment_history.full_name = params[:monthlypayconfirm][:"#{employee.emp_id}_full_name"]
      payment_history.hra = params[:monthlypayconfirm][:"#{employee.emp_id}_hra"]
      payment_history.basic = params[:monthlypayconfirm][:"#{employee.emp_id}_basic"]
      payment_history.tds = params[:monthlypayconfirm][:"#{employee.emp_id}_tds"]
      payment_history.special_allowance = params[:monthlypayconfirm][:"#{employee.emp_id}_special_allowance"]
      payment_history.conveyance = params[:monthlypayconfirm][:"#{employee.emp_id}_conveyance"]
      payment_history.medical_allowance = params[:monthlypayconfirm][:"#{employee.emp_id}_medical_allowance"]
      payment_history.professional_tax = params[:monthlypayconfirm][:"#{employee.emp_id}_professional_tax"]
      payment_history.net_monthly = params[:monthlypayconfirm][:"#{employee.emp_id}_net_monthly"]
      payment_history.tax_deducted = params[:monthlypayconfirm][:"#{employee.emp_id}_tax_deducted"]
      payment_history.loss_of_hours = params[:monthlypayconfirm][:"#{employee.emp_id}_sick"]
      payment_history.gross_monthly =params[:monthlypayconfirm][:"#{employee.emp_id}_gross_monthly"]
      payment_history.period_type="M"
      if payment_history.save
        PayPeriod.update(pay.id ,:status=>false)
      end
      end
    end
    
     respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=> @employees }
  end
  
  end
  # def deny_payroll
    # unless PaymentHistory.find_by_period_id(@period_id)
      # flash[:error]="payment already Done "
      # render "sessions/success"
    # end
  # end
  
end
