class AlterMeetings < ActiveRecord::Migration
  def self.up
    remove_column :meetings, :date
    add_column :meetings, :starts_at, :datetime
    add_column :meetings, :ends_at, :datetime
    add_column :meetings, :name, :string
  end

  def self.down
    add_column :meetings, :date, :datetime
    remove_column :meetings, :starts_at
    remove_column :meetings, :ends_at
    remove_column :meetings, :name
  end
end
