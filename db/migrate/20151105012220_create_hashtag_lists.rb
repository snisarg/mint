class CreateHashtagLists < ActiveRecord::Migration
  def change
    create_table :hashtag_lists do |t|
      t.integer :FK_tweet_id
      t.integer :FK_hashtag_id

      t.timestamps null: false
    end
  end
end
