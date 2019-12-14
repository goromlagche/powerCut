class UseCitext < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'citext'
    change_column :locations, :address, :citext
  end
end
