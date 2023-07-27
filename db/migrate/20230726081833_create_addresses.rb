class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :postal_code, null: false
      t.text :address, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
