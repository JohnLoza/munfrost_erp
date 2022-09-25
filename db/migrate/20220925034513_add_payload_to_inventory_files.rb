class AddPayloadToInventoryFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :inventory_files, :payload, :string
  end
end
