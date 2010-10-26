require 'test_helper'

class UserMessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: user_messages
#
#  id                   :integer(4)      not null, primary key
#  receiver_id          :integer(4)      not null
#  message_id           :integer(4)      not null
#  state                :string(255)
#  indirect_receiver_id :integer(4)
#

