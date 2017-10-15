require_relative '../db/sql_runner'

class TransactionCategory
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @transaction_id = options['transaction_id'].to_i
    @category_id = options['category_id'].to_i
  end

  def to_s
    "ID: #{@id}, Transaction ID: #{@transaction_id}
    and Category ID: #{@category_id}."
  end

  def save
    sql = 'INSERT INTO transaction_categories (transaction_id, category_id)
    VALUES ($1, $2) RETURNING id;'
    values = [@transaction_id, @category_id]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = 'UPDATE transaction_categories SET (transaction_id, category_id)
    = ($1, $2) WHERE id = $3;'
    values = [@transaction_id, @category_id, @id]
    SQL.run(sql, values)
  end

  def delete
    SQL.run('DELETE FROM transaction_categories WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM transaction_categories;', [])
  end

  def self.find_all
    SQL.run('SELECT * FROM transaction_categories;', []).map do |tran_cat_hash|
      TransactionCategory.new(tran_cat_hash)
    end
  end

  def self.find(id)
    result = SQL.run('SELECT * FROM transaction_categories WHERE id = $1;', [id])[0]
    TransactionCategory.new(result)
  end
end
