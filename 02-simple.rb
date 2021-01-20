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

  def reduce(_)
    self
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

  def reduce(environment)
    if left.reducible? || right.reducible?
      SimpleAdd.new(
        left.reduce(environment),
        right.reduce(environment)
      )
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

  def reduce(environment)
    if left.reducible? || right.reducible?
      SimpleAdd.new(
        left.reduce(environment),
        right.reduce(environment)
      )
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

  def reduce(environment)
    if left.reducible? || right.reducible?
      SimpleLessThan.new(
        left.reduce(environment),
        right.reduce(environment)
      )
    else
      SimpleBoolean.new(left.value < right.value)
    end
  end
end

class SimpleVariable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end

class SimpleDoNothing
  def to_s
  'do-nothing'
  end

  def inspect
    "«#{self}»"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def reducible?
    false
  end
end

class SimpleAssign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      [
        SimpleAssign.new(
          name,
          expression.reduce(environment)
        ),
        environment
      ]
    else
      [
        SimpleDoNothing.new,
        environment.merge({ name => expression })
      ]
    end
  end
end

class SimpleMachine < Struct.new(:statement, :environment)
  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def run
    while statement.reducible?
      puts "#{statement}, #{environment}"

      step
    end

    puts "#{statement}, #{environment}"
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
#   ),
#   {}
# ).run

# SimpleMachine.new(
#   SimpleLessThan.new(
#     SimpleNumber.new(5),
#     SimpleAdd.new(
#       SimpleNumber.new(2),
#       SimpleNumber.new(2)
#     )
#   ),
#   {}
# ).run

# SimpleMachine.new(
#   SimpleAdd.new(
#     SimpleVariable.new(:x),
#     SimpleVariable.new(:y)
#   ),
#   {
#     x: SimpleNumber.new(3),
#     y: SimpleNumber.new(4)
#   }
# ).run

SimpleMachine.new(
  SimpleAssign.new(
    :x,
    SimpleAdd.new(
      SimpleVariable.new(:x),
      SimpleNumber.new(1)
    )
  ),
  {
    x: SimpleNumber.new(2)
  }
).run
