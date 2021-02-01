class DenotationalNumber < Struct.new(:value)
  def to_ruby
    "-> e { #{value.inspect} }"
  end
end

class DenotationalBoolean < Struct.new(:value)
  def to_ruby
    "-> e { #{value.inspect} }"
  end
end

class DenotationalVariable < Struct.new(:name)
  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end
end

class DenotationalAdd < Struct.new(:left, :right)
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}).call(e) }"
  end
end

class DenotationalMultiply < Struct.new(:left, :right)
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }"
  end
end

class DenotationalLessThan < Struct.new(:left, :right)
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }"
  end
end

class DenotationalAssign < Struct.new(:name, :expression)
  def to_ruby
    "-> e { e.merge({ #{name.inspect} => (#{expression.to_ruby}).call(e) }) }"
  end
end

class DenotationalDoNothing
  def to_ruby
    '-> e { e }'
  end
end

class DenotationalIf < Struct.new(:condition, :consequence, :alternative)
  def to_ruby
    <<~EOF
      -> e {
        if (#{condition.to_ruby}).call(e)
          (#{consequence.to_ruby}).call(e) 
        else
          (#{alternative.to_ruby}).call(e) 
        end
      }
    EOF
  end
end

class DenotationalSequence < Struct.new(:first, :second)
  def to_ruby
    "-> e { (#{second.to_ruby}).call((#{first.to_ruby}).call(e)) }"
  end
end

class DenotationalWhile < Struct.new(:condition, :body)
  def to_ruby
    <<~EOF
      -> e {
        while (#{condition.to_ruby}).call(e)
          e = (#{body.to_ruby}).call(e)
        end

        e
      }
    EOF
  end
end

# proc = eval(
#   DenotationalAdd.new(
#     DenotationalVariable.new(:x),
#     DenotationalNumber.new(1)
#   ).to_ruby
# )

# proc = eval(
#   DenotationalLessThan.new(
#     DenotationalAdd.new(
#       DenotationalVariable.new(:x),
#       DenotationalNumber.new(1)
#     ),
#     DenotationalNumber.new(3)
#   ).to_ruby
# )

# statement = DenotationalAssign.new(
#   :y,
#   DenotationalAdd.new(
#     DenotationalVariable.new(:x),
#     DenotationalNumber.new(1)
#   )
# )

statement = DenotationalWhile.new(
  DenotationalLessThan.new(
    DenotationalVariable.new(:x),
    DenotationalNumber.new(5)
  ),
  DenotationalAssign.new(
    :x,
    DenotationalMultiply.new(
      DenotationalVariable.new(:x),
      DenotationalNumber.new(3)
    )
  )
)

proc = eval(statement.to_ruby)

environment = { x: 3 }
puts(proc.call(environment))
