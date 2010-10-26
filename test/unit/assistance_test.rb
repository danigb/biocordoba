require 'test_helper'

class AssistanceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: assistances
#
#  id            :integer(4)      not null, primary key
#  day           :date
#  arrive        :time
#  leave         :time
#  preference_id :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

