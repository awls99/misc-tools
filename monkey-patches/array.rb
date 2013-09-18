class Array

  #this method only works if you have Hash#deep_contains_pair?
  #@see Hash#deep_contains_pair?
  def deep_contains_pair? key, value
    self.each do |item|
      if item.respond_to? :deep_contains_pair?
        return true if item.deep_contains_pair? key,value
      end
    end
    return false
  end

  #checks if this array or any nested array has target
  #@see Hash#deep_contains
  def deep_contains? target
    self.each do |value|
      if value == target
        return true
      end
      if value.respond_to? :deep_contains?
        return true if value.deep_contains? target
      end
    end
    return false
  end


end