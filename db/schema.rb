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

ActiveRecord::Schema.define(version: 20140615181748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: true do |t|
    t.integer  "user_id"
    t.integer  "home_id"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homes", force: true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zip"
    t.decimal  "price"
  end

  create_table "images", force: true do |t|
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
  end

  create_table "zillows", force: true do |t|
    t.integer  "user_id"
    t.integer  "home_id"
    t.integer  "zpid"
    t.integer  "FIPScounty"
    t.string   "useCode"
    t.integer  "taxAssessmentYear"
    t.decimal  "taxAssessment"
    t.integer  "yearBuilt"
    t.integer  "lotSizeSqFt"
    t.integer  "finishedSqFt"
    t.decimal  "bathrooms"
    t.integer  "bedrooms"
    t.date     "lastSoldDate"
    t.integer  "lastSoldPrice"
    t.integer  "zestimate_amount"
    t.integer  "valuationRange_low"
    t.integer  "valuationRange_high"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
