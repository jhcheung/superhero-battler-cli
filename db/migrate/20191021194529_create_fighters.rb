class CreateFighters < ActiveRecord::Migration[6.0]
  def change
    create_table :fighters do |t|
      t.string :name
      t.integer :intelligence
      t.integer :strength
      t.integer :speed
      t.integer :durability
      t.integer :power
      t.integer :combat
    end
  end
end
