class CreateTweetData < ActiveRecord::Migration[6.0]
  def change
    create_table :tweet_data do |t|
      t.string :image_id, null: false, unique: true
      t.string :affected_areas
      t.datetime :restore_at
      t.text :raw_data

      t.timestamps
    end
  end
end
