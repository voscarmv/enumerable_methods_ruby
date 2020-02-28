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

  def my_select
    if block_given?
      output = Array.new
      self.my_each {|i| output << i if yield(i)}
      output
    else
      self.to_enum
    end
  end

  def my_all_check
    self.my_each do |i|
      return false unless yield(i)
    end
    true
  end

  def my_none_check
    self.my_each do |i|
      return false if yield(i)
    end
    true
  end
  

end

[1, 2, 3, 4].my_each {|x| puts "number: #{x}"}

[1, 2, 3, 4].my_each_with_index {|x, y| puts "number #{y}: #{x}"}

[1, 2, 3, 4].my_select { |i| i > 1 }

[0, 0, 0, 1, 2, 0].my_all_check {|i| i < 5}
[0, 0, 0, 1, 2, 0].my_none_check {|i| i > 1}

