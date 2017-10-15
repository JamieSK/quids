require 'pg'

class SQL
  def self.run(sql, values)
    begin
      db = PG.connect({dbname: 'quids', host: 'localhost'})
      db.prepare('tag', sql)
      return db.exec_prepared('tag', values)
    ensure
      db.close
    end
  end
end
