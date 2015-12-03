class AddingIndexes < ActiveRecord::Migration
  def change
    add_index(:tweets, [:latitude, :longitude])
  end
end
