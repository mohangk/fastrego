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

ActiveRecord::Schema.define(:version => 20130106091231) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "website"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "tournament_id"
  end

  create_table "participants", :force => true do |t|
    t.integer  "registration_id"
    t.string   "name"
    t.string   "gender"
    t.string   "email"
    t.string   "dietary_requirement"
    t.string   "allergies"
    t.datetime "arrival_at"
    t.string   "point_of_entry"
    t.string   "emergency_contact_person"
    t.string   "emergency_contact_number"
    t.string   "preferred_roommate"
    t.string   "preferred_roommate_institution"
    t.datetime "departure_at"
    t.integer  "speaker_number"
    t.integer  "team_number"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nationality"
    t.string   "passport_number"
    t.string   "transport_number"
    t.text     "data"
  end

  create_table "payments", :force => true do |t|
    t.string   "account_number"
    t.decimal  "amount_sent",                :precision => 14, :scale => 2
    t.date     "date_sent"
    t.text     "comments"
    t.decimal  "amount_received",            :precision => 14, :scale => 2
    t.text     "admin_comment"
    t.integer  "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scanned_proof_file_name"
    t.string   "scanned_proof_content_type"
    t.integer  "scanned_proof_file_size"
    t.datetime "scanned_proof_updated_at"
    t.string   "type"
    t.string   "status"
    t.string   "transaction_txnid"
    t.string   "invoice_number"
    t.string   "primary_receiver"
    t.string   "secondary_receiver"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "debate_teams_requested"
    t.integer  "adjudicators_requested"
    t.integer  "observers_requested"
    t.integer  "debate_teams_granted"
    t.integer  "adjudicators_granted"
    t.integer  "observers_granted"
    t.integer  "debate_teams_confirmed"
    t.integer  "observers_confirmed"
    t.integer  "adjudicators_confirmed"
    t.integer  "team_manager_id"
    t.datetime "requested_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "fees",                   :precision => 14, :scale => 2
    t.integer  "tournament_id"
    t.integer  "institution_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.boolean  "active",        :default => true
    t.string   "identifier"
    t.integer  "admin_user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                                                  :null => false
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
