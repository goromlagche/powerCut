class CreateLocation < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.datetime :restore_at, index: true
      t.string :address, null: false, unique: true
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
