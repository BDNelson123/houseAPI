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

ActiveRecord::Schema.define(version: 20140619180834) do

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
    t.string   "klass"
    t.boolean  "primary"
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
    t.integer  "fipsCounty"
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
    t.string   "valuationGraph_1year"
    t.string   "valuationGraph_5years"
    t.integer  "related_0_zpid"
    t.string   "related_0_address"
    t.string   "related_0_city"
    t.string   "related_0_state"
    t.integer  "related_0_zip"
    t.decimal  "related_0_latitude"
    t.decimal  "related_0_longitude"
    t.integer  "related_0_valuationRange_low"
    t.integer  "related_0_valuationRange_high"
    t.integer  "related_0_zestimate"
    t.integer  "related_0_taxAssessmentYear"
    t.decimal  "related_0_taxAssessment"
    t.integer  "related_0_yearBuilt"
    t.integer  "related_0_lotSizeSqFt"
    t.decimal  "related_0_bathrooms"
    t.integer  "related_0_bedrooms"
    t.date     "related_0_lastSoldDate"
    t.integer  "related_0_lastSoldPrice"
    t.integer  "related_1_zpid"
    t.string   "related_1_address"
    t.string   "related_1_city"
    t.string   "related_1_state"
    t.integer  "related_1_zip"
    t.decimal  "related_1_latitude"
    t.decimal  "related_1_longitude"
    t.integer  "related_1_valuationRange_low"
    t.integer  "related_1_valuationRange_high"
    t.integer  "related_1_zestimate"
    t.integer  "related_1_taxAssessmentYear"
    t.decimal  "related_1_taxAssessment"
    t.integer  "related_1_yearBuilt"
    t.integer  "related_1_lotSizeSqFt"
    t.decimal  "related_1_bathrooms"
    t.integer  "related_1_bedrooms"
    t.date     "related_1_lastSoldDate"
    t.integer  "related_1_lastSoldPrice"
    t.integer  "related_2_zpid"
    t.string   "related_2_address"
    t.string   "related_2_city"
    t.string   "related_2_state"
    t.integer  "related_2_zip"
    t.decimal  "related_2_latitude"
    t.decimal  "related_2_longitude"
    t.integer  "related_2_valuationRange_low"
    t.integer  "related_2_valuationRange_high"
    t.integer  "related_2_zestimate"
    t.integer  "related_2_taxAssessmentYear"
    t.decimal  "related_2_taxAssessment"
    t.integer  "related_2_yearBuilt"
    t.integer  "related_2_lotSizeSqFt"
    t.decimal  "related_2_bathrooms"
    t.integer  "related_2_bedrooms"
    t.date     "related_2_lastSoldDate"
    t.integer  "related_2_lastSoldPrice"
    t.integer  "region_id"
    t.string   "region_name"
    t.string   "demographics_medianCondoValue"
    t.string   "demographics_medianHomeValue"
    t.string   "demographics_dollarsPerSquareFeet"
    t.string   "demographics_zillowHomeValueIndexDistribution"
    t.string   "demographics_homeType"
    t.string   "demographics_ownersVsRenters"
    t.string   "demographics_homeSizeInSquareFeet"
    t.string   "demographics_yearBuilt"
    t.integer  "demographics_zillowHomeValueIndex"
    t.integer  "demographics_medianSingleFamilyHomeValue"
    t.integer  "demographics_medianCondoValueAmount"
    t.integer  "demographics_median2BedroomHomeValue"
    t.integer  "demographics_median3BedroomHomeValue"
    t.integer  "demographics_median4BedroomHomeValue"
    t.decimal  "demographics_percentHomesDecreasing"
    t.decimal  "demographics_percentListingPriceReduction"
    t.integer  "demographics_medianListPricePerSqFt"
    t.integer  "demographics_medianListPrice"
    t.integer  "demographics_medianSalePrice"
    t.integer  "demographics_medianValuePerSqFt"
    t.integer  "demographics_propertyTax"
  end

end
