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

puts BigStepNumber
  .new(23)
  .evaluate({})

puts BigStepVariable
  .new(:x)
  .evaluate(
    {
      x: BigStepNumber.new(23)
    }
  )

puts BigStepLessThan
  .new(
    BigStepAdd.new(
      BigStepVariable.new(:x),
      BigStepNumber.new(2)
    ),
    BigStepVariable.new(:y)
  ).evaluate(
    {
      x: BigStepNumber.new(2),
      y: BigStepNumber.new(5)
    }
  )
