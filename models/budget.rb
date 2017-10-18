require 'date'

require_relative '../db/sql_runner.rb'

# Models budget for quids budgeting app.
class Budget
  attr_reader :id, :cash_spent
  attr_accessor :cash_max

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @user_id = options['user_id'].to_i
    @start_date = Date.strptime(options['start_date'], '%Y-%M-%d')
    @end_date = Date.strptime(options['end_date'], '%Y-%M-%d')
    @cash_spent = options['cash_spent'].to_i
    @cash_max = options['cash_max'].to_i
  end

  def to_s
    "ID: #{@id}, User id: #{@user_id}, Date: #{@start_date} - #{@end_date} and
    Cash: #{@cash_spent}/#{@cash_max}."
  end

  def spend_stats
    "#{@cash_spent}/#{@cash_max}"
  end

  def save
    sql = 'INSERT INTO budgets
    (user_id, start_date, end_date, cash_spent, cash_max)
    VALUES ($1, $2, $3, $4, $5) RETURNING id;'
    values = [@user_id, @start_date, @end_date, @cash_spent, @cash_max]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = 'UPDATE budgets SET
    (user_id, start_date, end_date, cash_spent, cash_max) = ($1, $2, $3, $4, $5)
    WHERE id = $6;'
    values = [@user_id, @start_date, @end_date, @cash_spent, @cash_max, @id]
    SQL.run(sql, values)
  end

  def check_spend
    sql = 'SELECT SUM(amount) FROM transactions WHERE budget_id = $1'
    @cash_spent = SQL.run(sql, [@id])[0]['sum'].to_i
    update
  end

  def overbudget?
    check_spend
    @cash_spent > @cash_max
  end

  def delete
    SQL.run('DELETE FROM budgets WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM budgets;', [])
  end

  def self.find_all
    SQL.run('SELECT * FROM budgets;', []).map do |budget_hash|
      Budget.new(budget_hash)
    end
  end

  def self.find(id)
    Budget.new(SQL.run('SELECT * FROM budgets WHERE id = $1;', [id])[0])
  end
end
