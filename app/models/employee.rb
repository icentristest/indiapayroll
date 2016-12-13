class Employee < ActiveRecord::Base
  attr_accessible :address, :bank_acc_no, :date_of_birth, :date_of_joining, :date_of_relieve, :designation, :email_id, :emp_id, :first_name, :gender, :grossCTC, :last_name, :pan_number, :phone_number, :status
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :first_name,:last_name , :presence => true,
                    :length   => { :maximum => 50 }
  #validates :phone_number ,:presence=> true  ,:length => {:maximum=> 10 ,:minimum=>10}
  validates :date_of_birth ,:date_of_joining ,:designation ,:bank_acc_no ,
                     :grossCTC ,:pan_number ,:address , :presence => true  
  validates :emp_id ,:presence=> true ,:uniqueness => true             
  validates :email_id, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  has_many :payment_histories
  has_many :bonus
  
end
