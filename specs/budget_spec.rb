require 'minitest/autorun'
require 'minitest/rg'

require_relative '../db/seeds'

require_relative '../models/category'
require_relative '../models/merchant'
require_relative '../models/transaction'
require_relative '../models/transaction_category'
require_relative '../models/user'
require_relative '../models/budget'

class BudgetTest < MiniTest::Test
  def setup
    Category.delete_all
    Merchant.delete_all
    Transaction.delete_all
    TransactionCategory.delete_all
    Budget.delete_all
    User.delete_all

    @jamie = User.new({
      'name' => 'Jamie',
      'picture' => ''
      })
    @jamie.save

    @budget = Budget.new({
      'user_id' => @jamie.id,
      'start_date' => '2017-01-01',
      'end_date' => '2017-12-31',
      'cash_spent' => 0,
      'cash_max' => 500
      })
    @budget.save

    @shopping = Category.new({
      'name' => 'Shopping'
      })
    @shopping.save

    @eating = Category.new({
      'name' => 'Eating'
      })
    @eating.save

    @paesano = Merchant.new({
      'category_id' => @eating.id,
      'name' => 'paesano'
      })
    @paesano.save

    @john_lewis = Merchant.new({
      'category_id' => @shopping.id,
      'name' => 'john lewis'
      })
    @john_lewis.save

    @tesco = Merchant.new({
      'name' => 'tesco'
      })
    @tesco.save

    @pizza = Transaction.new({
      'description' => 'Pizza, pizza, pizza.',
      'merchant_id' => @paesano.id,
      'user_id' => @jamie.id,
      'budget_id' => @budget.id,
      'amount' => 8,
      'transaction_time' => '2017-10-5 20:39:00',
      'categories' => [@paesano.category_id]
      })
    @pizza.save

    @groceries = Transaction.new({
      'description' => 'Boring food, not pizza.',
      'merchant_id' => @tesco.id,
      'user_id' => @jamie.id,
      'budget_id' => @budget.id,
      'amount' => 37,
      'transaction_time' => '2017-10-6 22:30:00',
      'categories' => [@eating.id, @shopping.id]
      })
    @groceries.save

    @budget.check_spend
  end

  def test_overspend_budget_check
    # Refute that one is overbudget.
    refute(@budget.overbudget?)

    # Buy something extortionate.
    Transaction.new({
      'description' => 'Really expensive teapot.',
      'merchant_id' => @john_lewis.id,
      'user_id' => @jamie.id,
      'budget_id' => @budget.id,
      'amount' => 600,
      'transaction_time' => '2017-10-5 08:14:00',
      'categories' => [@shopping.id]
      }).save

    # Assert that one is now overbudget.
    assert(@budget.overbudget?)
    # Shouldn't have bought that teapot.
    # HTTP 418.
  end
end
