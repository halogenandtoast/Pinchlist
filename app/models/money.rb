class Money
  def initialize(cents)
    @cents = cents
  end

  def dollars
    @cents.to_f / 100.0
  end

  def to_s
    "$%0.2f" % dollars
  end
end
