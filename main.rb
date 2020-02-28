module Enumerable

  def make_array(input)
    if input.class == Range
      input.to_a
    else
      input
    end
  end

  def my_each
    arr = make_array(self)
    if block_given?
      for i in (0..arr.length-1) do
        yield(arr[i])
      end  
    else
      arr.to_enum
    end
  end

  def my_each_2
    arr = make_array(self)
    if block_given?
      for i in (1..arr.length-1) do
        yield(arr[i])
      end  
    else
      arr.to_enum
    end
  end

  def my_each_with_index
    arr = make_array(self)
    if block_given?
      [0..arr.length - 1].my_each {|i| yield(arr[i],i)}
    else
      arr.to_enum
    end
  end 

  def my_select
    arr = make_array(self)
    if block_given?
      output = Array.new
      arr.my_each {|i| output << i if yield(i)}
      output
    else
      arr.to_enum
    end
  end

  def my_all_check
    arr = make_array(self)
    arr.my_each { |i| return false unless yield(i) }
    true
  end

  def my_none_check
    arr = make_array(self)
    arr.my_each { |i| return false if yield(i) }
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

  def my_count
    arr = make_array(self)
    if block_given?
      count = 0
      arr.my_each {|i| count += 1 if yield(i)}
      count
    else
      arr.length
    end
  end

  def my_map(proc = nil)
    arr = make_array(self)
    output = Array.new
    if proc.class == Proc
      arr.my_each { |i| output << i if proc.call(i)}
      output
    elsif block_given?
      arr.my_each {|i| output << i if yield(i)}
      output
    else
      arr.to_enum
    end
  end

  def my_inject(first = nil, second = nil)
    arr = make_array(self)
    accum = arr[0]
    if first.class == Symbol
      arr.my_each_2 { |i| accum = accum.send(first, i) }
      accum
    elsif !first.nil? && second.nil?
      if block_given?
        accum = first
        arr.my_each { |i| accum = yield(accum, i) }
        accum
      end
    elsif !first.nil? && second.class == Symbol
      accum = first
      arr.my_each { |i| accum = accum.send(second, i) }
      accum
    elsif first.nil? && second.nil?
      if block_given?
        arr.my_each_2 { |i| accum = yield(accum, i) }
        accum
      end
    end
  end

end

def multiply_els(input)
  input.my_inject(:*)
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

ary = [1, 2, 4, 2]
ary.count               #=> 4
ary.count(2)            #=> 2
ary.count{ |x| x%2==0 } #=> 3

(1..10).my_map { |i| i * 2 if i.even? } #=> [4, 8, 12, 16, 20]

# Sum some numbers
(5..10).my_inject(:+)                             #=> 45
# Same using a block and inject
(5..10).my_inject { |sum, n| sum + n }            #=> 45
# Multiply some numbers
(5..10).my_inject(1, :*)                          #=> 151200
# Same using a block
(5..10).my_inject(1) { |product, n| product * n } #=> 151200
# find the longest word
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
longest                                        #=> "sheep"

multiply_els([2,4,5])

myproc = proc { |i| i > 2 }
[0, 0, 0, 1, 0, 2, 3, 4].my_map(myproc)