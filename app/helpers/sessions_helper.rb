module SessionsHelper
 
 
 def sign_in(user)
    cookies.permanent[:remember_token] = user.id

  end
  def login_as(user)
    cookies.permanent[:login_as] =user
    self.login_as =user
  end
  
  def current_user
     @current_user ||= UserLogin.find_by_id(cookies[:remember_token]) 
    #unless @current_user.nil?
     # @current_user =Employee.find_by_emp_id(cookies[:employee])
      #end 
  end
  def employee_view
    if @current_user.emp_id.nil?
      @employee=cookies[:employee]
    else
      @current_user.emp_id
    end
  end
  def login_as=(user)
    @login_as = user
  end
  def login_as?
    @login_as=='admin'
  end
  def is_admin?

     if current_user && current_user.is_admin=="y"
       return true
     else 
       return false
      end
  end
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    #self.current_user = nil
    cookies.delete(:remember_token)
  end


  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def authenticate_admin
    deny_access_for_employee unless @current_user.is_admin
  end
  def deny_access_for_employee
    store_location
    redirect_to empinfo_path, :notice => "Please sign in as a admin to access  this page."
  end

  def deny_access
    store_location
    redirect_to new_session_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
  
  private

    def user_from_remember_token
      Admin.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end


    def clear_return_to
      session[:return_to] = nil
    end
     
  
end
