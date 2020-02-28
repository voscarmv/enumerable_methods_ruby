module Enumerable

  def my_each
    if block_given?
      for i in (0..self.length-1) do
        yield(self[i])
      end  
    else
      self.to_enum
    end
  end

  def my_each_with_index
    if block_given?
      [0..length - 1].my_each {|i| yield(self[i],i)}
    else
      self.to_enum
    end
  end

end

[1, 2, 3, 4].my_each {|x| puts "number: #{x}"}

[1, 2, 3, 4].my_each_with_index {|x, y| puts "number #{y}: #{x}"}