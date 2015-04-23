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
  #@note supports nested arrays
  #example:
  # {'a' => {'b' => 1}}.deep_key('a.b') #=> 1
  def deep_key key_list
    raise ArgumentError unless key_list.class == String
    keys        = key_list.split '.'
    current_val = nil
    keys.each do |key|
      if !current_val
        current_val = self[ key ]
      elsif current_val.is_a? Array
        current_val = current_val[ key.to_i ]
      else
        current_val = current_val[ key ]
      end
      return nil unless current_val
    end
    return current_val
  end


  #@param args
  #returns arrays for each arg with values for key arg for each arg key on this or nested hash
  #Similar to Hash#values_at, but includes values for nested hashes inside self
  #@note if args.legnth == 1 flat array
  def deep_values_at *args
    values = args.map do |target_key|
      found = []
      self.each do |key, value|
        if key == target_key
          found.push value
        else
          if value.respond_to? :deep_values_at
            found.concat value.deep_values_at( target_key )
          end
        end
      end
      found
    end
    values.flatten if args.length < 2
  end

  
end