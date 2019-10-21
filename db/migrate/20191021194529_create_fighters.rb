class CreateFighters < ActiveRecord::Migration[6.0]
  def change
    create_table :fighters do |t|
      t.string :name
    end
  end
end
