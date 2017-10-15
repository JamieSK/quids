require_relative '../db/sql_runner.rb'

class Category
  attr_reader :id

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

  def self.find_all
    SQL.run('SELECT * FROM categories;', []).map do |category_hash|
      Category.new(category_hash)
    end
  end

  def self.find(id)
    Category.new(SQL.run('SELECT * FROM categories WHERE id = $1;', [id])[0])
  end
end
