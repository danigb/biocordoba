class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.integer :host_id
      t.integer :guest_id
      t.datetime :date
      t.string :state
      t.text :note_host
      t.text :note_guest
      t.text :cancel_reason

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
