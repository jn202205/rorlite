class Status < SQLObject
  belongs_to :cat

  self.finalize!
end
