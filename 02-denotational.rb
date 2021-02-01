class DenotationalNumber < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def to_ruby
    "-> e { #{value.inspect} }"
  end
end

class DenotationalBoolean < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def to_ruby
    "-> e { #{value.inspect} }"
  end
end

class DenotationalVariable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "«#{self}»"
  end

  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end
end

class DenotationalAdd < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}).call(e) }"
  end
end

class DenotationalMultiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }"
  end
end

class DenotationalLessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }"
  end
end

# proc = eval(
#   DenotationalAdd.new(
#     DenotationalVariable.new(:x),
#     DenotationalNumber.new(1)
#   ).to_ruby
# )

proc = eval(
  DenotationalLessThan.new(
    DenotationalAdd.new(
      DenotationalVariable.new(:x),
      DenotationalNumber.new(1)
    ),
    DenotationalNumber.new(3)
  ).to_ruby
)

environment = { x: 3 }
puts(proc.call(environment))
