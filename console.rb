require_relative 'models/category'
require_relative 'models/merchant'
require_relative 'models/transaction'
require_relative 'models/transaction_category'
require_relative 'models/user'
require_relative 'models/budget'
require_relative 'models/ordinalize'

# puts Transaction.list_all

# puts Budget.find(8).spend_stats

# puts Category.find(16).total

# puts "Before arrogant teapot purchase:", Budget.find(8).overbudget?, ''
# Transaction.new({
#   'description' => 'Really expensive teapot.',
#   'merchant_id' => 23,
#   'user_id' => 8,
#   'budget_id' => 8,
#   'amount' => 600,
#   'transaction_time' => '2017-10-5 08:14:00',
#   'categories' => [15]
#   }).save
# puts 'After arrogant teapot purchase:', Budget.find(8).overbudget?

# Transaction.find(14).delete
