# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_14_122048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.datetime "restore_at"
    t.citext "address", null: false
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restore_at"], name: "index_locations_on_restore_at"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "url", null: false
    t.string "affected_areas"
    t.datetime "restore_at"
    t.text "raw_data"
    t.boolean "location_fetched", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "to_tsvector('english'::regconfig, raw_data)", name: "articles_name", using: :gin
  end

end
