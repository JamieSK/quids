require_relative '../db/sql_runner.rb'

class Category
  attr_reader :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name'].gsub(/\b\w/, &:capitalize)
  end

  def to_s
    "ID: #{@id} and Name: #{@name}."
  end

  def save
    sql = 'INSERT INTO categories (name) VALUES ($1) RETURNING id;'
    values = [@name]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def update
    SQL.run('UPDATE categories SET (name) = ($1) WHERE id = $2;', [@name, @id])
  end

  def delete
    SQL.run('DELETE FROM categories WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM categories;', [])
  end

  def delete_if_empty
    count = SQL.run('SELECT COUNT(*) FROM transaction_categories WHERE category_id = $1;', [@id])[0]['count'].to_i
    delete if count < 1
  end

  def self.find_all
    SQL.run('SELECT * FROM categories;', []).map do |category_hash|
      Category.new(category_hash)
    end
  end

  def self.find(id)
    Category.new(SQL.run('SELECT * FROM categories WHERE id = $1;', [id])[0])
  end

  def total
    sql = 'SELECT SUM(transactions.amount) FROM transactions INNER JOIN transaction_categories ON transactions.id = transaction_categories.transaction_id WHERE transaction_categories.category_id = $1;'
    SQL.run(sql, [@id])[0]['sum']
  end

  def self.find_name(name)
    results = SQL.run('SELECT * FROM categories;', [])
    result = results.select do |category|
      category['name'].downcase == name.downcase
    end
    if result.first.nil?
      new_category = Category.new({'name' => name})
      new_category.save
      return new_category.id
    else
      return result[0]['id'].to_i
    end
  end

  def list_all
    sql = 'SELECT transactions.* FROM transactions INNER JOIN transaction_categories ON transactions.id = transaction_id WHERE category_id = $1;'
    results = SQL.run(sql, [@id])
    results.map do |transaction|
      transaction = Transaction.new(transaction)
    end
  end
end
