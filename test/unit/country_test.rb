require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: countries
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  code           :string(255)
#  profiles_count :integer(4)      default(0)
#

