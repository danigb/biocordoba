require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: meetings
#
#  id            :integer(4)      not null, primary key
#  host_id       :integer(4)
#  guest_id      :integer(4)
#  state         :string(255)
#  note_host     :text
#  note_guest    :text
#  cancel_reason :text
#  created_at    :datetime
#  updated_at    :datetime
#  starts_at     :datetime
#  ends_at       :datetime
#

