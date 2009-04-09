class String
  def /(o)
    File.join(self, o.to_s)
  end
end
