require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/category'
require_relative '../models/merchant'
require_relative '../models/transaction'
require_relative '../models/transaction_category'
require_relative '../models/user'
require_relative '../models/budget'

class MerchantTest < MiniTest::Test
  def test_find_by_name
    assert_equal(78, Merchant.find_name('Tesco'))
  end

  def test_not_found_by_name
    assert_nil(Merchant.find_name('Harrods'))
  end

  def test_find_wrong_case
    assert_equal(78, Merchant.find_name('tesco'))
  end
end
