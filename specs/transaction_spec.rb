require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/transaction'
require_relative '../models/merchant'
require_relative '../models/user'
require_relative '../models/budget'

# Tests transaction class
class TransactionTest < MiniTest::Test
  def setup
    @test_user = User.new('name' => 'test mcTesting')
    @test_user.save
    @test_budget = Budget.new(
      'user_id' => @test_user.id,
      'start_date' => '2016-01-01',
      'end_date' => '2016-12-31',
      'cash_spent' => 0,
      'cash_max' => 100
    )
    @test_budget.save
    @test_category = Category.new('name' => 'test')
    @test_category.save
    @test_merchant = Merchant.new('name' => 'test')
    @test_merchant.save
    @test_transaction = Transaction.new(
      'description' => 'test',
      'merchant_id' => @test_merchant.id,
      'user_id' => @test_user.id,
      'budget_id' => @test_budget.id,
      'amount' => 42,
      'transaction_time' => '2017-10-22 15:18:00',
      'categories' => [@test_category.name]
    )
    @test_transaction.save
  end

  def teardown
    @test_transaction.delete
    @test_budget.delete
    @test_user.delete
    @test_category.delete
    @test_merchant.delete
    skipped?
  end
end
