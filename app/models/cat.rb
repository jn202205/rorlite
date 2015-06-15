class Cat < SQLObject
  has_many :statuses
  belongs_to :human, foreign_key: :owner_id
  has_one_through :house, :human, :house

  self.finalize!
end
