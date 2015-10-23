class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :hashtag
      t.text :tweet_text
      t.string :location

      t.timestamps null: false
    end
  end
end
