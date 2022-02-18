class AddMatchesEmailSentAtToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :matches_email_sent_at, :datetime
  end
end
