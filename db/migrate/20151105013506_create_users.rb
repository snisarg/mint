class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :name
      t.text :screen_name
      t.text :location

      t.timestamps null: false
    end
  end
end
