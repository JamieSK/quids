require 'date'

require_relative '../db/sql_runner'
require_relative 'transaction_category'
require_relative 'merchant'
require_relative 'user'
require_relative 'budget'
require_relative 'ordinalize'
require_relative 'category'

class Transaction
  attr_reader :id, :description, :merchant_id, :user_id, :budget_id, :amount, :transaction_time, :categories

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @description = options['description']
    @merchant_id = options['merchant_id'].to_i
    @user_id = options['user_id'].to_i
    @budget_id = options['budget_id'].to_i
    @amount = options['amount'].to_i
    @transaction_time = DateTime.strptime(options['transaction_time'],
      '%Y-%m-%d %H:%M:%S')
    @categories = options['categories']
  end

  def to_s
    "ID: #{@id}, Description: #{@description}, Merchant ID: #{@merchant_id}, User ID: #{@user_id}, Budget ID: #{@budget_id}, Amount: #{@amount} and Time: #{@transaction_time}."
  end

  def save
    sql = 'INSERT INTO transactions
    (description, merchant_id, user_id, budget_id, amount, transaction_time)
    VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;'
    values = [@description, @merchant_id, @user_id, @budget_id, @amount, @transaction_time]
    @id = SQL.run(sql, values)[0]['id'].to_i
    save_categories
  end

  def save_categories
    @categories.each do |category|
      TransactionCategory.new({
        'category_id' => category,
        'transaction_id' => @id}
      ).save
    end
  end

  def self.options_from_form(options)
    options['merchant_id'] = Merchant.find_name(options['merchant'])
    options['user_id'] = User.find_all.first.id
    options['budget_id'] = Budget.find_all.first.id
    options['categories'] = options['category'].split(', ').map { |category|
      Category.find_name(category)
    }
    options['transaction_time'] = "#{options['date']} #{options['time']}:00"
    options
  end

  def update
    sql = 'UPDATE transactions SET
    (description, merchant_id, user_id, budget_id, amount, transaction_time)
    = ($1, $2, $3, $4, $5, $6) WHERE id = $7;'
    values = [@description, @merchant_id, @user_id, @budget_id, @amount, @transaction_time, @id]
    SQL.run(sql, values)

    # Delete transaction_categories for transaction.
    TransactionCategory.delete_where_transaction(@id)
    # Re-add them for categories array.
    save_categories
  end

  def delete
    SQL.run('DELETE FROM transactions WHERE id = $1;', [@id])
    find_categories.each { |category| category.delete_if_empty }
    Merchant.find(@merchant_id).delete_if_empty
  end

  def self.delete_all
    SQL.run('DELETE FROM transactions;', [])
  end

  def self.delete_empties
    Category.find_all.each { |category| category.delete_if_empty }
    Merchant.find_all.each { |merchant| merchant.delete_if_empty }
  end

  def self.find_all
    SQL.run('SELECT * FROM transactions ORDER BY transaction_time DESC;', []).map do |transaction_hash|
      Transaction.new(transaction_hash)
    end
  end

  def self.find(id)
    Transaction.new(SQL.run('SELECT * FROM transactions WHERE id = $1;', [id])[0])
  end

  def find_merchant
    Merchant.find(@merchant_id)
  end

  def find_categories
    sql = 'SELECT categories.* FROM transaction_categories INNER JOIN categories ON category_id = categories.id WHERE transaction_id = $1;'
    categories = SQL.run(sql, [@id]).map do |category|
      Category.new(category)
    end
  end

  def list_category_names
    out = find_categories.each_with_object('') do |category, out|
      out << category.name << ', '
    end
    out[0...-2]
    # Removes final comma.
  end

  def list
    info = "'%s' at %s for £%s." % extract_print_info
  end

  def self.list_all
    find_all.map do |transaction|
      info = "'%s' at %s for £%s." % transaction.extract_print_info
    end
  end

  def print_day
    @transaction_time.strftime("%A #{@transaction_time.day.ordinalize} %B")
  end

  def time
    @transaction_time.strftime("%A #{@transaction_time.day.ordinalize} %B, %R")
  end

  def extract_print_info
    merchant =  Merchant.find(@merchant_id).name
    user = User.find(@user_id).name
    description = @description
    price = @amount

    [description, merchant, price]
  end

  def self.group_by_day(results)
    results.each_with_object(hash = {}) do |transaction|
      transaction_day = transaction.transaction_time.strftime('%Y-%m-%d')
      if hash.has_key?(transaction_day)
        hash[transaction_day] << transaction
      else
        hash[transaction_day] = [transaction]
      end
    end
  end

  def self.group_by_month(results)
    results.each_with_object(hash = {}) do |transaction|
      transaction_month = transaction.transaction_time.strftime('%Y-%m')
      if hash.has_key?(transaction_month)
        hash[transaction_month] << transaction
      else
        hash[transaction_month] = [transaction]
      end
    end
  end
end
