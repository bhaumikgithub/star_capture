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

ActiveRecord::Schema.define(version: 2018_06_25_105216) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "average_caches", force: :cascade do |t|
    t.bigint "rater_id"
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "avg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_type", "rateable_id"], name: "index_average_caches_on_rateable_type_and_rateable_id"
    t.index ["rater_id"], name: "index_average_caches_on_rater_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "category_template_id"
    t.index ["category_template_id"], name: "index_categories_on_category_template_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "product_id", null: false
    t.index ["category_id", "product_id"], name: "index_categories_products_on_category_id_and_product_id"
    t.index ["product_id", "category_id"], name: "index_categories_products_on_product_id_and_category_id"
  end

  create_table "category_templates", force: :cascade do |t|
    t.string "template_name"
    t.jsonb "name", default: {"optional"=>false, "required"=>false}
    t.jsonb "price", default: {"optional"=>false, "required"=>false}
    t.jsonb "description", default: {"optional"=>false, "required"=>false}
    t.jsonb "short_description", default: {"optional"=>false, "required"=>false}
    t.jsonb "image", default: {"optional"=>false, "required"=>false}
    t.jsonb "multiple_images", default: {"optional"=>false, "required"=>false}
    t.jsonb "google_map_link", default: {"optional"=>false, "required"=>false}
    t.jsonb "product_type", default: {"optional"=>false, "required"=>false}
    t.jsonb "map_location", default: {"optional"=>false, "required"=>false}
    t.jsonb "location", default: {"optional"=>false, "required"=>false}
    t.jsonb "mon_to_sat_on", default: {"optional"=>false, "required"=>false}
    t.jsonb "mon_to_sat_open_time", default: {"optional"=>false, "required"=>false}
    t.jsonb "mon_to_sat_close_time", default: {"optional"=>false, "required"=>false}
    t.jsonb "entry_fee_adult", default: {"optional"=>false, "required"=>false}
    t.jsonb "entry_fee_toddler", default: {"optional"=>false, "required"=>false}
    t.jsonb "entry_fee_child", default: {"optional"=>false, "required"=>false}
    t.jsonb "entry_fee_senior_citizen", default: {"optional"=>false, "required"=>false}
    t.jsonb "ratings", default: {"optional"=>false, "required"=>false}
    t.jsonb "parking_type", default: {"optional"=>false, "required"=>false}
    t.jsonb "parking_fees", default: {"optional"=>false, "required"=>false}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "currency", default: {"optional"=>false, "required"=>false}
    t.jsonb "entry_fee_foreigner", default: {"optional"=>false, "required"=>false}
    t.jsonb "allow_like", default: {"optional"=>false, "required"=>false}
    t.jsonb "allow_comment", default: {"optional"=>false, "required"=>false}
    t.jsonb "allow_ratings", default: {"optional"=>false, "required"=>false}
    t.jsonb "allow_ratings_comment", default: {"optional"=>false, "required"=>false}
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.string "duration"
    t.datetime "end_date"
    t.string "price"
    t.string "expenses"
    t.string "min_members"
    t.boolean "not_fixed"
    t.bigint "transport_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.bigint "user_id"
    t.string "duration_type"
    t.string "status", default: "pending"
    t.string "max_members"
    t.boolean "member_not_fixed"
    t.index ["transport_type_id"], name: "index_itineraries_on_transport_type_id"
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "itinerary_products", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "itinerary_schedule_id"
    t.datetime "timing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_schedule_id"], name: "index_itinerary_products_on_itinerary_schedule_id"
    t.index ["product_id"], name: "index_itinerary_products_on_product_id"
  end

  create_table "itinerary_schedules", force: :cascade do |t|
    t.time "pickup_time"
    t.text "pickup_location"
    t.boolean "no_pickup"
    t.time "drop_time"
    t.text "drop_location"
    t.boolean "no_drop"
    t.bigint "itinerary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_itinerary_schedules_on_itinerary_id"
  end

  create_table "overall_averages", force: :cascade do |t|
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "overall_avg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_type", "rateable_id"], name: "index_overall_averages_on_rateable_type_and_rateable_id"
  end

  create_table "product_comments", force: :cascade do |t|
    t.bigint "product_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["product_id"], name: "index_product_comments_on_product_id"
    t.index ["user_id"], name: "index_product_comments_on_user_id"
  end

  create_table "product_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "pincode"
    t.text "description"
    t.text "short_description"
    t.string "google_map_link"
    t.bigint "product_type_id"
    t.string "map_location"
    t.string "location"
    t.boolean "mon_to_sat_on"
    t.datetime "mon_to_sat_open_time"
    t.datetime "mon_to_sat_close_time"
    t.float "entry_fee_adult"
    t.float "entry_fee_toddler"
    t.float "entry_fee_child"
    t.float "entry_fee_senior_citizen"
    t.string "ratings"
    t.string "parking_type"
    t.float "parking_fees"
    t.jsonb "timings"
    t.string "currency"
    t.float "entry_fee_foreigner"
    t.boolean "allow_comment", default: false
    t.boolean "view_comments", default: false
    t.boolean "allow_like", default: false
    t.boolean "view_likes", default: false
    t.index ["product_type_id"], name: "index_products_on_product_type_id"
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "rater_id"
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "stars", null: false
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.index ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
    t.index ["rateable_type", "rateable_id"], name: "index_rates_on_rateable_type_and_rateable_id"
    t.index ["rater_id"], name: "index_rates_on_rater_id"
  end

  create_table "rating_caches", force: :cascade do |t|
    t.string "cacheable_type"
    t.bigint "cacheable_id"
    t.float "avg", null: false
    t.integer "qty", null: false
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"
    t.index ["cacheable_type", "cacheable_id"], name: "index_rating_caches_on_cacheable_type_and_cacheable_id"
  end

  create_table "transport_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role", default: "user"
    t.float "latitude"
    t.float "longitude"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  add_foreign_key "categories", "category_templates"
  add_foreign_key "categories", "users"
  add_foreign_key "itineraries", "transport_types"
  add_foreign_key "itineraries", "users"
  add_foreign_key "itinerary_products", "itinerary_schedules"
  add_foreign_key "itinerary_products", "products"
  add_foreign_key "itinerary_schedules", "itineraries"
  add_foreign_key "product_comments", "products"
  add_foreign_key "product_comments", "users"
  add_foreign_key "products", "product_types"
end
