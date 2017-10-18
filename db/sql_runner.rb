require 'pg'

# Runner for SQL queries in quids database.
class SQL
  def self.run(sql, values)
    db = PG.connect(dbname: 'quids', host: 'localhost')
    db.prepare('tag', sql)
    return db.exec_prepared('tag', values)
  ensure
    db.close
  end
end
