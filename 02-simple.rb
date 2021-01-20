class SimpleNumber < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    false
  end
end

class SimpleAdd < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      SimpleAdd.new(left.reduce, right)
    elsif right.reducible?
      SimpleAdd.new(left, right.reduce)
    else
      SimpleNumber.new(
        left.value + right.value
      )
    end
  end
end

class SimpleMultiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      SimpleAdd.new(left.reduce, right)
    elsif right.reducible?
      SimpleAdd.new(left, right.reduce)
    else
      SimpleNumber.new(
        left.value * right.value
      )
    end
  end
end

class SimpleBoolean < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    false
  end
end

class SimpleLessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      SimpleLessThan.new(left.reduce, right)
    elsif right.reducible?
      SimpleLessThan.new(left, right.reduce)
    else
      SimpleBoolean.new(left.value < right.value)
    end
  end
end

class SimpleMachine < Struct.new(:expression)
  def step
    self.expression = expression.reduce
  end

  def run
    while expression.reducible?
      puts expression
      step
    end

    puts expression
  end
end

# SimpleMachine.new(
#   SimpleAdd.new(
#     SimpleMultiply.new(
#       SimpleNumber.new(1),
#       SimpleNumber.new(2)
#     ),
#     SimpleMultiply.new(
#       SimpleNumber.new(3),
#       SimpleNumber.new(4)
#     )
#   )
# ).run

SimpleMachine.new(
  SimpleLessThan.new(
    SimpleNumber.new(5),
    SimpleAdd.new(
      SimpleNumber.new(2),
      SimpleNumber.new(2)
    )
  )
).run
