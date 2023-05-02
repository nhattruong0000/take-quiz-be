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

ActiveRecord::Schema[7.0].define(version: 2023_04_25_082034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "card_collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.uuid "user_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_card_collections_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "index_card_collections_on_status"
    t.index ["user_id"], name: "index_card_collections_on_user_id"
  end

  create_table "cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "question", null: false
    t.string "answer", null: false
    t.string "picture_url"
    t.boolean "set_favorite", default: false
    t.integer "success_count", default: 0
    t.integer "failed_count", default: 0
    t.integer "study_count", default: 0
    t.datetime "study_last_time"
    t.integer "order_no", default: 0
    t.string "status", default: "active"
    t.boolean "is_public", default: false
    t.uuid "card_collection_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer"], name: "index_cards_on_answer", opclass: :gin_trgm_ops, using: :gin
    t.index ["card_collection_id"], name: "index_cards_on_card_collection_id"
    t.index ["is_public"], name: "index_cards_on_is_public"
    t.index ["question"], name: "index_cards_on_question", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "index_cards_on_status", opclass: :gin_trgm_ops, using: :gin
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "study_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "card_id", null: false
    t.uuid "study_session_id", null: false
    t.integer "question_type", null: false
    t.string "status", default: "active"
    t.jsonb "questions", null: false
    t.jsonb "answers", null: false
    t.jsonb "results", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answers"], name: "index_study_cards_on_answers", using: :gin
    t.index ["card_id"], name: "index_study_cards_on_card_id"
    t.index ["questions"], name: "index_study_cards_on_questions", using: :gin
    t.index ["results"], name: "index_study_cards_on_results", using: :gin
    t.index ["study_session_id"], name: "index_study_cards_on_study_session_id"
  end

  create_table "study_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "card_collection_id", null: false
    t.string "status", default: "active"
    t.jsonb "configs", default: {}
    t.integer "order_no"
    t.jsonb "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_study_sessions_on_status", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "test_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "card_id", null: false
    t.uuid "test_session_id", null: false
    t.integer "question_type", null: false
    t.string "status", default: "active"
    t.jsonb "questions", null: false
    t.jsonb "answers", null: false
    t.jsonb "results", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answers"], name: "index_test_cards_on_answers", using: :gin
    t.index ["card_id"], name: "index_test_cards_on_card_id"
    t.index ["questions"], name: "index_test_cards_on_questions", using: :gin
    t.index ["results"], name: "index_test_cards_on_results", using: :gin
    t.index ["test_session_id"], name: "index_test_cards_on_test_session_id"
  end

  create_table "test_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "card_collection_id", null: false
    t.string "status", default: "active"
    t.jsonb "configs", default: {}
    t.integer "order_no"
    t.jsonb "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_test_sessions_on_status", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "must_change_password", default: false
    t.string "initial_password", default: ""
    t.string "role", default: "customer"
    t.string "locale", default: "en"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
