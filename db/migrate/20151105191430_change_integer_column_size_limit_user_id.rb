class ChangeIntegerColumnSizeLimitUserId < ActiveRecord::Migration
  def change
    change_column :tweets, :in_reply_to_status_id, :integer, :limit => 8
    change_column :tweets, :in_reply_to_user_id, :integer, :limit => 8
    change_column :users, :twitter_id, :integer, :limit => 8
    change_column :mentions, :FK_user_id, :integer, :limit => 8
  end
end
