class ChangeIntegerColumnSizeLimitTweets < ActiveRecord::Migration
  def change
    change_column :tweets, :FK_user_id, :integer, :limit => 8
  end
end
