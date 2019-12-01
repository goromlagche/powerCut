class CreateTweet < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.string :url, null: false, unique: true
      t.string :affected_areas
      t.datetime :restore_at
      t.text :raw_data
      t.boolean :location_fetched, default: false, null: false

      t.timestamps
    end
  end
end
