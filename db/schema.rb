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

ActiveRecord::Schema.define(version: 2021_02_20_021624) do

  create_table "actors", id: :string, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
  end

  create_table "genres", id: :string, force: :cascade do |t|
    t.string "label"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.string "runtime"
    t.string "director"
    t.string "plot"
    t.string "poster_url"
    t.string "rating"
    t.string "page_url"
  end

  create_table "movies_actors", id: false, force: :cascade do |t|
    t.string "movie_id"
    t.string "actor_id"
  end

  create_table "movies_genres", id: false, force: :cascade do |t|
    t.string "movie_id"
    t.string "genre_id"
  end

  add_foreign_key "movies_actors", "actors"
  add_foreign_key "movies_actors", "movies"
  add_foreign_key "movies_genres", "genres"
  add_foreign_key "movies_genres", "movies"
end
