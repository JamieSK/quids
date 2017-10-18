require_relative 'models/category'
require_relative 'models/merchant'
require_relative 'models/transaction'
require_relative 'models/transaction_category'
require_relative 'models/user'
require_relative 'models/budget'
require_relative 'models/ordinalize'

# puts Transaction.list_all

# puts Budget.find_all[0].spend_stats

# puts Category.find_all[1].total

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
# puts 'After arrogant teapot purchase:', Budget.find_all[0].overbudget?

# Transaction.find(14).delete

# p Category.find_all[1].list_all

# p Transaction.find(56).list_category_names

# p Transaction.find_grouped_by_month

# p Category.find(54).delete_if_empty

# p Merchant.find_all.each { |m| m.delete_if_empty }

# by_month = Transaction.group_by_month(Transaction.find_all)
# by_month.keys.each do |month_key|
#   by_month[month_key] = Transaction.group_by_day(by_month[month_key])
# end
# p by_month

# p Category.colours

Category.find(56).delete_if_empty
