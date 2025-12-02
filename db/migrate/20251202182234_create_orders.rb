class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :status
      t.decimal :total
      t.decimal :subtotal
      t.decimal :tax_amount
      t.references :province, null: false, foreign_key: true
      t.text :shipping_address
      t.string :payment_id

      t.timestamps
    end
  end
end
