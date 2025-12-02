class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.references :category, null: false, foreign_key: true
      t.string :sku
      t.integer :stock_quantity
      t.boolean :on_sale
      t.decimal :sale_price

      t.timestamps
    end
  end
end
