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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2015_02_04_204927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discounts", force: :cascade do |t|
    t.integer "invited_user_id"
    t.integer "user_id"
    t.integer "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "invited_user_id"
    t.boolean "paid", default: false
    t.boolean "used_discount", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["invited_user_id"], name: "index_invitations_on_invited_user_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "list_bases", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "list_base_id"
    t.integer "position"
    t.string "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "public_token"
    t.string "slug", default: "list", null: false
    t.boolean "public", default: false
    t.string "title"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "title"
    t.integer "list_base_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "due_date"
    t.boolean "completed", default: false
    t.date "completed_at"
    t.integer "position", default: 1
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "invitation_token", limit: 20
    t.datetime "invitation_sent_at"
    t.boolean "admin", default: false
    t.integer "lists_count", default: 0
    t.string "stripe_customer_token"
    t.date "starts_at"
    t.date "ends_at"
    t.text "status", default: "inactive"
    t.string "timezone", default: "America/New_York"
    t.integer "available_credit", default: 0
    t.datetime "invitation_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
