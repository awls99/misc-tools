require 'thwait'

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

  #uses each but opens a new thread for each element
  #@param abort[Boolean] if true sets abort_on_exception on each thread
  def threaded_each abort = true, &block
    threads = []
    self.each do |element|
      thread = Thread.new do
        yield(element)
      end
      thread.abort_on_exception if abort
      threads.push thread
    end
    ThreadsWait.all_waits(*threads)
  end

  #@see Hash#deep_values_at with nested arrays
  #@param args
  #returns arrays for each arg with values for key arg for each arg key on this or nested hash
  #Similar to Hash#values_at, but includes values for nested hashes inside self
  #@note if args.legnth == 1 flat array
  def deep_values_at *args
    values = args.map do |target_key|
      found = []
      self.each do |value|
        if value.respond_to? :deep_values_at
          found.concat value.deep_values_at( target_key )
        end
      end
      found
    end
    values.flatten if args.length < 2
  end


end