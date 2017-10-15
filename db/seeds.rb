require_relative '../models/category'
require_relative '../models/merchant'
require_relative '../models/transaction'
require_relative '../models/transaction_category'
require_relative '../models/user'
require_relative '../models/budget'

Category.delete_all
Merchant.delete_all
Transaction.delete_all
TransactionCategory.delete_all
Budget.delete_all
User.delete_all

jamie = User.new({
  'name' => 'Jamie',
  'picture' => ''
  })
jamie.save

budget = Budget.new({
  'user_id' => jamie.id,
  'start_date' => '01/01/2017',
  'end_date' => '31/12/2017',
  'cash_spent' => 0,
  'cash_max' => 500
  })
budget.save

shopping = Category.new({
  'name' => 'Shopping'
  })
shopping.save

eating = Category.new({
  'name' => 'Eating'
  })
eating.save

paesano = Merchant.new({
  'category_id' => eating.id,
  'name' => 'paesano'
  })
paesano.save

john_lewis = Merchant.new({
  'category_id' => shopping.id,
  'name' => 'john lewis'
  })
john_lewis.save

tesco = Merchant.new({
  'name' => 'tesco'
  })
tesco.save

pizza = Transaction.new({
  'description' => 'Pizza, pizza, pizza.',
  'merchant_id' => paesano.id,
  'user_id' => jamie.id,
  'budget_id' => budget.id,
  'amount' => 8,
  'transaction_time' => '05/10/2017 20:39',
  'categories' => [paesano.category_id]
  })
pizza.save

groceries = Transaction.new({
  'description' => 'Boring food, not pizza.',
  'merchant_id' => tesco.id,
  'user_id' => jamie.id,
  'budget_id' => budget.id,
  'amount' => 37,
  'transaction_time' => '06/10/2017 22:30',
  'categories' => [eating.id, shopping.id]
  })
groceries.save

budget.check_spend
