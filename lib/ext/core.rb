class String
  def /(o)
    File.join(self, o.to_s)
  end
end

class Symbol
  def /(o)
    File.join(self.to_s, o.to_s)
  end
end
