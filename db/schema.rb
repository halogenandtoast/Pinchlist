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

ActiveRecord::Schema.define(:version => 20120521163830) do

  create_table "discounts", :force => true do |t|
    t.integer  "invited_user_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discounts", ["user_id"], :name => "index_discounts_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invited_user_id"
    t.boolean  "paid",            :default => false
    t.boolean  "used_discount",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["invited_user_id"], :name => "index_invitations_on_invited_user_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "list_proxies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.integer  "position"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "public_token"
  end

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.text     "title"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "due_date"
    t.boolean  "completed",    :default => false
    t.date     "completed_at"
    t.integer  "position",     :default => 1
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",                 :null => false
    t.string   "encrypted_password",                  :default => ""
    t.string   "password_salt",                       :default => ""
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",      :limit => 20
    t.datetime "invitation_sent_at"
    t.boolean  "admin",                               :default => false
    t.integer  "list_proxies_count",                  :default => 0
    t.string   "stripe_customer_token"
    t.date     "starts_at"
    t.date     "ends_at"
    t.text     "status",                              :default => "inactive"
    t.string   "timezone",                            :default => "America/New_York"
    t.integer  "available_credit",                    :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
