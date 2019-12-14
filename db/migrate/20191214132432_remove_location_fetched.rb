class RemoveLocationFetched < ActiveRecord::Migration[6.0]
  def change
    remove_column :tweets, :location_fetched
  end
end
