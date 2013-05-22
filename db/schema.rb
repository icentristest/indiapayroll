# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130516141030) do

  create_table "bonus", :force => true do |t|
    t.string   "emp_id"
    t.string   "period_id"
    t.string   "period_type"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.decimal  "ps_1",        :precision => 10, :scale => 0
    t.decimal  "ps_2",        :precision => 10, :scale => 0
    t.decimal  "ps_3",        :precision => 10, :scale => 0
    t.decimal  "ps_4",        :precision => 10, :scale => 0
    t.decimal  "others",      :precision => 10, :scale => 0
  end

  create_table "config_tables", :force => true do |t|
    t.decimal  "hra_percent",            :precision => 10, :scale => 0
    t.decimal  "basic_percent",          :precision => 10, :scale => 0
    t.decimal  "conveyance",             :precision => 10, :scale => 0
    t.decimal  "professional_tax",       :precision => 10, :scale => 0
    t.decimal  "edu_cess",               :precision => 10, :scale => 0
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "year"
    t.decimal  "medical_receipts_limit", :precision => 10, :scale => 0
    t.decimal  "limit_80c",              :precision => 10, :scale => 0
    t.decimal  "h_loan_limit",           :precision => 10, :scale => 0
    t.decimal  "medical_allowance",      :precision => 10, :scale => 0
  end

  create_table "emp_declarations", :force => true do |t|
    t.string   "emp_id"
    t.string   "hra_status"
    t.decimal  "total_hra",                    :precision => 10, :scale => 0
    t.decimal  "medical_receipts",             :precision => 10, :scale => 0
    t.decimal  "insurance_80c",                :precision => 10, :scale => 0
    t.decimal  "ppf_80c",                      :precision => 10, :scale => 0
    t.decimal  "mf_80c",                       :precision => 10, :scale => 0
    t.decimal  "hloan_principal_80c",          :precision => 10, :scale => 0
    t.decimal  "nsc_80c",                      :precision => 10, :scale => 0
    t.decimal  "children_fee_80c",             :precision => 10, :scale => 0
    t.decimal  "infrabonds_80c",               :precision => 10, :scale => 0
    t.decimal  "others_80c",                   :precision => 10, :scale => 0
    t.decimal  "med_insurance_80d",            :precision => 10, :scale => 0
    t.decimal  "donations_80g",                :precision => 10, :scale => 0
    t.decimal  "interest_EduLoan_80e",         :precision => 10, :scale => 0
    t.string   "house_self_occupied"
    t.decimal  "house_rent",                   :precision => 10, :scale => 0
    t.decimal  "home_loan_interest",           :precision => 10, :scale => 0
    t.string   "updated_by"
    t.string   "locked_for_employee"
    t.string   "locked_for_admin"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.decimal  "rent_receipts_total",          :precision => 10, :scale => 0
    t.decimal  "rent_receipts_cal1",           :precision => 10, :scale => 0
    t.decimal  "rent_receipts_cal2",           :precision => 10, :scale => 0
    t.decimal  "pf_80c",                       :precision => 10, :scale => 0
    t.decimal  "emp_contr_new_pension_scheme", :precision => 10, :scale => 0
    t.decimal  "contr_pension_plan",           :precision => 10, :scale => 0
    t.decimal  "term_deposit",                 :precision => 10, :scale => 0
    t.decimal  "medical_expenditure_80ddb",    :precision => 10, :scale => 0
    t.decimal  "permanent_ph_disability_80u",  :precision => 10, :scale => 0
    t.decimal  "pre_employment_salary",        :precision => 10, :scale => 0
    t.decimal  "pre_employment_tds",           :precision => 10, :scale => 0
    t.decimal  "other_deductions",             :precision => 10, :scale => 0
  end

  create_table "employees", :force => true do |t|
    t.string   "emp_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "email_id"
    t.text     "address"
    t.integer  "phone_number"
    t.string   "pan_number"
    t.integer  "bank_acc_no"
    t.string   "designation"
    t.string   "grossCTC"
    t.date     "date_of_joining"
    t.date     "date_of_birth"
    t.date     "date_of_relieve"
    t.boolean  "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "pay_periods", :force => true do |t|
    t.string   "period_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "period_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "current_fyear"
  end

  create_table "payment_histories", :force => true do |t|
    t.string   "emp_id"
    t.string   "period_id"
    t.string   "period_type"
    t.decimal  "gross_monthly",     :precision => 10, :scale => 0
    t.decimal  "basic",             :precision => 10, :scale => 0
    t.decimal  "hra",               :precision => 10, :scale => 0
    t.decimal  "conveyance",        :precision => 10, :scale => 0
    t.decimal  "medical_allowance", :precision => 10, :scale => 0
    t.decimal  "professional_tax",  :precision => 10, :scale => 0
    t.decimal  "loss_of_hours",     :precision => 10, :scale => 0
    t.decimal  "tax_deducted",      :precision => 10, :scale => 0
    t.decimal  "net_monthly",       :precision => 10, :scale => 0
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.decimal  "tds",               :precision => 10, :scale => 0
    t.decimal  "special_allowance", :precision => 10, :scale => 0
    t.string   "full_name"
  end

  create_table "tax_slabs", :force => true do |t|
    t.decimal  "slab_from",         :precision => 10, :scale => 0
    t.decimal  "slab_to",           :precision => 10, :scale => 0
    t.decimal  "deduction_percent", :precision => 10, :scale => 0
    t.decimal  "min_tax",           :precision => 10, :scale => 0
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "year"
  end

  create_table "user_logins", :force => true do |t|
    t.string   "emp_id"
    t.string   "user_name"
    t.string   "password"
    t.date     "last_logged_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.boolean  "is_admin"
  end

end
