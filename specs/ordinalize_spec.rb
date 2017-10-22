require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/ordinalize'

# Tests the ordinalize method even though it's relatively simple.
class OrdinalizeTest < MiniTest::Test
  def test_teens
    (11..19).each do |number|
      ordinalized = number.ordinalize
      assert_equal(number.to_s + 'th', ordinalized)
    end
  end

  def test_one
    assert_equal('1st', 1.ordinalize)
  end

  def test_two
    assert_equal('2nd', 2.ordinalize)
  end

  def test_three
    assert_equal('3rd', 3.ordinalize)
  end
end
