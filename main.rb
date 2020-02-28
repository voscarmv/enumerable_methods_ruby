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
    self.my_each { |i| return false unless yield(i) }
    true
  end

  def my_none_check
    self.my_each { |i| return false if yield(i) }
    true
  end

  def my_all?(expr = nil)
    if expr.class == Regexp
      my_all_check { |i| i =~ expr }
    elsif expr.class == Class
      my_all_check { |i| i.is_a? expr }
    elsif block_given?
      my_all_check { |i| yield(i) }
    else
      my_all_check { |i| i == false || i.nil? }
    end
  end

  def my_none?(expr = nil)
    if expr.class == Regexp
      my_none_check { |i| i =~ expr }
    elsif expr.class == Class
      my_none_check { |i| i.is_a? expr }
    elsif block_given?  
      my_none_check { |i| yield(i) }
    else
      my_none_check { |i| i == false || i.nil? }
    end
  end

end

[1, 2, 3, 4].my_each {|x| puts "number: #{x}"}

[1, 2, 3, 4].my_each_with_index {|x, y| puts "number #{y}: #{x}"}

[1, 2, 3, 4].my_select { |i| i > 1 }

[0, 0, 0, 1, 2, 0].my_all? {|i| i < 5}
%w(oscar, apple, dark).my_all?(/a/)
[1, 2i, 3.14].my_all?(Numeric)

%w{ant bear cat}.my_none? { |word| word.length >= 4 }
%w{ant bear cat}.my_none?(/d/)
[1, 3.14, 42].my_none?(Float)


