# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_11_002341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "price_data", force: :cascade do |t|
    t.datetime "date_time", null: false
    t.float "open", null: false
    t.float "high", null: false
    t.float "low", null: false
    t.float "close", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "trading_day"
    t.string "trading_session"
    t.string "period"
    t.float "onh"
    t.float "onl"
    t.float "fhh"
    t.float "fhl"
    t.index ["date_time"], name: "index_price_data_on_date_time", unique: true
  end

  create_table "stats", force: :cascade do |t|
    t.date "trading_day", null: false
    t.string "breach_onh"
    t.string "breach_onl"
    t.string "breach_fhh"
    t.string "breach_fhl"
    t.string "breach_ah"
    t.string "breach_al"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trading_day"], name: "index_stats_on_trading_day", unique: true
  end

end
