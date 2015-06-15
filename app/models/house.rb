class House < SQLObject
  has_many :humans
  has_many_through :cats, :humans, :cats

  self.finalize!
end
