class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :FK_tweet_id
      t.integer :FK_user_id

      t.timestamps null: false
    end
  end
end
