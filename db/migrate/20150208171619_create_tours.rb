class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.json :data, default: []
    end
  end
end
