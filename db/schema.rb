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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141101191325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", id: false, force: true do |t|
    t.boolean  "current",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at"
    t.integer  "student_id",                 null: false
    t.integer  "team_id",                    null: false
  end

  create_table "offers", id: false, force: true do |t|
    t.integer  "shares"
    t.date     "cliff_date"
    t.datetime "offer_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at"
    t.boolean  "signed",      default: false
    t.datetime "date_signed"
    t.integer  "student_id",                  null: false
    t.integer  "team_id",                     null: false
    t.boolean  "answered",    default: false
    t.boolean  "expired",     default: false
  end

  create_table "students", force: true do |t|
    t.string  "netid"
    t.string  "firstname",                 null: false
    t.boolean "admin",     default: false
    t.string  "lastname",                  null: false
    t.string  "email",                     null: false
  end

  create_table "students_teams", id: false, force: true do |t|
    t.integer "student_id"
    t.integer "team_id"
  end

  create_table "teams", force: true do |t|
    t.integer  "total_shares"
    t.integer  "shares_distributed"
    t.string   "ceo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
    t.integer  "held_shares",        default: 0
  end

end
