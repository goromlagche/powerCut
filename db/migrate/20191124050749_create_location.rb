class CreateLocation < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.belongs_to :tweet_data, index: true, foreign_key: true
      t.datetime :restore_at, index: true
      t.string :address, null: false, unique: true
      t.json :geo_json

      t.timestamps
    end
  end
end
