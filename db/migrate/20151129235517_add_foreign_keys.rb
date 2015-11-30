class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :hashtag_lists, :hashtags, column: :FK_hashtag_id, primary_key: :id
    add_foreign_key :hashtag_lists, :tweets, column: :FK_tweet_id, primary_key: :id
    remove_column :users, :id
    execute "ALTER TABLE mint.users ADD PRIMARY KEY (twitter_id);"
    add_foreign_key :tweets, :users, column: :FK_user_id, primary_key: :twitter_id
    add_foreign_key :mentions, :tweets, column: :FK_tweet_id, primary_key: :id
    add_foreign_key :mentions, :users, column: :FK_user_id, primary_key: :twitter_id
  end
end
