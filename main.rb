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

end

[1, 2, 3, 4].my_each {|x| puts "number: #{x}"}