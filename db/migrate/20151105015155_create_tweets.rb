class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :text
      t.text :coordinates
      t.text :country_code
      t.text :location_full_name
      t.integer :FK_user_id
      t.integer :in_reply_to_user_id
      t.integer :in_reply_to_status_id
      t.integer :retweet_count
      t.integer :favorite_count
      t.text :timestamp
      t.text :source

      t.timestamps null: false
    end
  end
end
