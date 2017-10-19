require_relative '../db/sql_runner.rb'

# Models mercchant class for merchants table for quids budgeting app.
class Merchant
  attr_reader :id
  attr_accessor :category_id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @category_id = options['category_id'].to_i if options['category_id']
    @name = options['name'].gsub(/\b\w/, &:capitalize)
  end

  def to_s
    "ID: #{@id}, Category ID: #{@category_id} and Name: #{@name}."
  end

  def save
    sql = 'INSERT INTO merchants (name, category_id)
    VALUES ($1, $2) RETURNING id;'
    values = [@name, @category_id]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = 'UPDATE merchants SET (name, category_id) = ($1, $2) WHERE id = $3;'
    SQL.run(sql, [@name, @category_id, @id])
  end

  def total
    sql = 'SELECT SUM(amount) FROM transactions WHERE merchant_id = $1;'
    SQL.run(sql, [@id])[0]['sum']
  end

  def delete
    SQL.run('DELETE FROM merchants WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM merchants;', [])
  end

  def delete_if_empty
    sql = 'SELECT COUNT(*) FROM transactions WHERE merchant_id = $1;'
    count = SQL.run(sql, [@id])[0]['count'].to_i
    delete if count < 1
  end

  def self.find_all
    SQL.run('SELECT * FROM merchants;', []).map do |merchant_hash|
      Merchant.new(merchant_hash)
    end
  end

  def self.find(id)
    Merchant.new(SQL.run('SELECT * FROM merchants WHERE id = $1;', [id])[0])
  end

  def self.find_name(name)
    result = SQL.run('SELECT * FROM merchants;', []).select do |merchant|
      merchant['name'].casecmp(name)
    end
    return result[0]['id'].to_i unless result.first.nil?
    new_merchant = Merchant.new({'name' => name})
    new_merchant.save
    return new_merchant.id
  end

  def list_all
    sql = 'SELECT transactions.* FROM transactions WHERE merchant_id = $1
      ORDER BY transaction_time DESC;'
    results = SQL.run(sql, [@id])
    results.map do |transaction|
      Transaction.new(transaction)
    end
  end
end
