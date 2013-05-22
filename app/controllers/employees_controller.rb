class EmployeesController < ApplicationController
  include SessionsHelper 
   layout :resolve_layout
   before_filter :authenticate  ,:except=>[:popup]
   before_filter :authenticate_admin , :only=>[:new ,:create ,:index]
   
  
  # GET /employees
  # GET /employees.json
  def index
    
    @employees = Employee.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=> @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=> @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=> @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(params[:employee])
   
    respond_to do |format|
      user =UserLogin.new
      user.emp_id=@employee.emp_id
      user.user_name=@employee.emp_id
      user.password= ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join
      user.is_admin='n'
      @employee.status=true
      if @employee.save && user.save 
        UserMailer.emp_registration(@employee,user).deliver
        format.html { redirect_to @employee, :notice=> 'Employee was successfully created.' }
        format.json { render :json=> @employee, :status=>created, :location=> @employee }
      else
        format.html { render :action=> "new" }
        format.json { render :json=> @employee.errors, :status=>unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to @employee, :notice=> 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action=> "edit" }
        format.json { render :json=> @employee.errors, :status=>unprocessable_entity }
      end
    end
  end
  
  
  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee = Employee.find(params[:id])
    Employee.update(params[:id] ,:status=>false ,:date_of_relieve =>Time.now)

    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end
  # employee info 
  def employeeinfo
   @employee=Employee.find_by_emp_id(current_user.emp_id)
  end
  def admin_view
    employee_id=params[:emp_id]
    @employee=Employee.find_by_emp_id(employee_id)
    cookies.permanent[:employee] =employee_id
    login_as "admin"
    render "employeeinfo"
  end
  
    private

  def resolve_layout
    case action_name
    when "employeeinfo" ,"admin_view"
      "employee"
    else
      "application"
    end
  end
  
  

end
