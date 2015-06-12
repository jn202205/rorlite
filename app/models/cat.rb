class Cat < SQLObject
  has_many :statuses

  self.finalize!
end
