require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  sender_id  :integer(4)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#  subject    :string(255)
#

