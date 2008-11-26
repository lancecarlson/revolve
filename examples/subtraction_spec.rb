require File.join(File.dirname(__FILE__), "..", "revolve")

class Integer
  def protected_division(divisor)
    return 1 if divisor == 0
    self / divisor
  end
end


def cases(num, step, first, second)
  (1..num).map do |i|
    lambda do |program|
      my_first = first + step*i
      program.run( Revolve::Argument.new(:x, my_first), 
                   Revolve::Argument.new(:y, second)).to_i - (my_first - second)
    end
  end
end

describe "Subtraction" do  
  instructions do
    erk(-5, -4, -3, -2, -1, 1, 2, 3, 4, 5)
    methods(:+, :-, :*, :protected_division)
    parameters(:x, :y)
  end
  
  it "should have a return value of 533 given 900 and 367" do
  end
end

# x - y

