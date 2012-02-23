
module EntityMethods
  def wounded?
    health < max_health
  end

  def wound
    @health = @health - 1
  end

  def empty?
    false
  end

end