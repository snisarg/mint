class ChangeIntegerColumnSizeLimit < ActiveRecord::Migration
  def change
    change_column :tweets, :in_reply_to_status_id, :integer, :limit => 8
  end
end
