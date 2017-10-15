require 'date'

require_relative '../db/sql_runner.rb'
require_relative 'transaction_category.rb'

class Transaction
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @description = options['description']
    @merchant_id = options['merchant_id'].to_i
    @user_id = options['user_id'].to_i
    @budget_id = options['budget_id'].to_i
    @amount = options['amount'].to_i
    @transaction_time = DateTime.strptime(options['transaction_time'],
      '%d/%M/%Y %H:%M')
    @categories = options['categories']
  end

  def to_s
    "ID: #{@id}, Description: #{@description} Merchant ID: #{@merchant_id}, User ID: #{@user_id},
    Budget ID: #{@budget_id}, Amount: #{@amount} and Time: #{@transaction_time}."
  end

  def save
    sql = 'INSERT INTO transactions
    (description, merchant_id, user_id, budget_id, amount, transaction_time)
    VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;'
    values = [@description, @merchant_id, @user_id, @budget_id, @amount, @transaction_time]
    @id = SQL.run(sql, values)[0]['id'].to_i

    @categories.each do |category|
      TransactionCategory.new({
        'category_id' => category,
        'transaction_id' => @id}
      ).save
    end
  end

  def update
    sql = 'UPDATE transactions SET
    (description, merchant_id, user_id, budget_id, amount, transaction_time)
    = ($1, $2, $3, $4, $5, $6) WHERE id = $7;'
    values = [@description, @merchant_id, @user_id, @budget_id, @amount, @transaction_time, @id]
    SQL.run(sql, values)
  end

  def delete
    SQL.run('DELETE FROM transactions WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM transactions;', [])
  end

  def self.find_all
    SQL.run('SELECT * FROM transactions;', []).map do |transaction_hash|
      Transaction.new(transaction_hash)
    end
  end

  def self.find(id)
    Transaction.new(SQL.run('SELECT * FROM transactions WHERE id = $1;', [id])[0])
  end
end
