require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/category'
require_relative '../models/merchant'
require_relative '../models/transaction'
require_relative '../models/transaction_category'
require_relative '../models/user'
require_relative '../models/budget'

class CategoryTest < MiniTest::Test
  def test_find_by_name
    assert_equal(51, Category.find_name('Shopping'))
  end

  def test_not_found_by_name
    assert_nil(Category.find_name('Parachuting'))
  end

  def test_find_wrong_case
    assert_equal(52, Category.find_name('eating'))
  end
end
