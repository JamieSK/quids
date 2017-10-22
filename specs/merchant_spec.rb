require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/merchant'

# Tests the merchant class for the quids budgeting app.
class MerchantTest < MiniTest::Test
  def setup
    @test_merchant = Merchant.new('name' => 'test')
    @test_merchant.save
  end

  def test_find_by_name
    assert_equal(@test_merchant.id, Merchant.find_name('Test'))
  end

  def test_not_found_by_name_adds_merchant
    num_merchants = Merchant.find_all.length
    assert_instance_of(Integer, Merchant.find_name('Harrods'))
    assert_equal(num_merchants + 1, Merchant.find_all.length)
  end

  def test_find_wrong_case
    assert_equal(@test_merchant.id, Merchant.find_name('test'))
  end

  def teardown
    Merchant.find(Merchant.find_name('Harrods')).delete
    @test_merchant.delete
    skipped?
  end
end
