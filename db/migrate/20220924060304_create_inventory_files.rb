class CreateInventoryFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_files do |t|
      t.string :file
      t.text :error_msg
      t.text :error_location

      t.timestamps
    end
  end
end
