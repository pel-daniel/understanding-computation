class BigStepNumber < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    self
  end
end

class BigStepBoolean < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    self
  end
end

class BigStepVariable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    environment[name]
  end
end

class BigStepAdd < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    BigStepNumber.new(
      left.evaluate(environment).value +
      right.evaluate(environment).value
    )
  end
end

class BigStepMultiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    BigStepNumber.new(
      left.evaluate(environment).value *
      right.evaluate(environment).value
    )
  end
end

class BigStepLessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    BigStepBoolean.new(
      left.evaluate(environment).value <
      right.evaluate(environment).value
    )
  end
end

class BigStepAssign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    environment.merge(
      {
        name => expression.evaluate(environment)
      }
    )
  end
end

class BigStepDoNothing
  def to_s
    'do-nothing'
  end

  def inspect
    "«#{self}»"
  end

  def ==(other_statement)
    other_statement.instance_of?(SimpleDoNothing)
  end

  def evaluate(environment)
    environment
  end
end

class BigStepIf < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    case condition.evaluate(environment)
    when BigStepBoolean.new(true)
      consequence.evaluate(environment)
    when BigStepBoolean.new(false)
      alternative.evaluate(environment)
    end
  end
end

class BigStepSequence < Struct.new(:first, :second)
  def to_s
    "#{first}; #{second}"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    second.evaluate(
      first.evaluate(environment)
    )
  end
end

class BigStepWhile < Struct.new(:condition, :body)
  def to_s
    "while (#{condition}) { #{body} }"
  end

  def inspect
    "«#{self}»"
  end

  def evaluate(environment)
    case condition.evaluate(environment)
    when BigStepBoolean.new(true)
      evaluate(
        body.evaluate(environment)
      )
    when BigStepBoolean.new(false)
      environment
    end
  end
end


# Expressions

# puts(
#   BigStepNumber
#     .new(23)
#     .evaluate({})
# )

# puts(
#   BigStepVariable
#     .new(:x)
#     .evaluate(
#       {
#         x: BigStepNumber.new(23)
#       }
#     )
# )

# puts(
#   BigStepLessThan
#     .new(
#       BigStepAdd.new(
#         BigStepVariable.new(:x),
#         BigStepNumber.new(2)
#       ),
#       BigStepVariable.new(:y)
#     ).evaluate(
#       {
#         x: BigStepNumber.new(2),
#         y: BigStepNumber.new(5)
#       }
#     )
# )


# Statements

# statement = BigStepSequence.new(
#   BigStepAssign.new(
#     :x,
#     BigStepAdd.new(
#       BigStepNumber.new(1),
#       BigStepNumber.new(1)
#     )
#   ),
#   BigStepAssign.new(
#     :y,
#     BigStepAdd.new(
#       BigStepVariable.new(:x),
#       BigStepNumber.new(3)
#     )
#   )
# )

# puts(statement)
# puts(
#   statement.evaluate({})
# )

statement = BigStepWhile.new(
  BigStepLessThan.new(
    BigStepVariable.new(:x),
    BigStepNumber.new(5)
  ),
  BigStepAssign.new(
    :x,
    BigStepMultiply.new(
      BigStepVariable.new(:x),
      BigStepNumber.new(3)
    )
  )
)

puts(statement)
puts(
  statement.evaluate(
    {
      x: BigStepNumber.new(1)
    }
  )
)
