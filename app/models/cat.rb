require_relative '../../lib/sql_object'

class Cat < SQLObject
  has_many :statuses
  belongs_to :human, foreign_key: :owner_id

  self.finalize!
end
