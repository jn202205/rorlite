require_relative '../../lib/sql_object'

class Human < SQLObject
  self.table_name = 'humans'
  has_many :cats, foreign_key: :owner_id

  self.finalize!
end
