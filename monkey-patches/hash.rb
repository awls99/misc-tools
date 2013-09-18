# -*- encoding : utf-8 -*-
class Hash

  #checks if this hash or any nested hash has target value
  #@see Array#deep_contains?
  def deep_contains? target
    self.each do |key, value|
      if key == target or value == target
        return true
      end
      if value.respond_to? :deep_contains?
        return true if value.deep_contains? target
      end
    end
    return false
  end

  #checks if this hash or any nested hash has the passed key,value pair
  #@note Array#deep_contains_pair? only makes sense with this method
  #@see Array#deep_contains_pair?
  def deep_contains_pair? key, value
    if self[ key ] == value
      return true
    end
    self.each do |k,v|
      if v.respond_to? :deep_contains_pair?
        return true if v.deep_contains_pair? key, value
      end
    end
    return false
  end

  #@param key_list[String] dot separated values to mark keys in nested hashes
  #returns the value of a nested hash following the path in key_list
  #example:
  # {'a' => {'b' => 1}}.deep_key('a.b') #=> 1
  def deep_key key_list
    raise ArgumentError unless key_list.class == String
    keys        = key_list.split '.'
    current_val = nil
    keys.each do |key|
      if !current_val
        current_val = self[ key ]
      else
        current_val = current_val[ key ]
      end
      return nil unless current_val
    end
    return current_val
  end
  
end