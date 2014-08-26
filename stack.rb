class Stack

  def initialize
    @values = []
  end

  def push(value)
    raise ArgumentError if value.nil?

    @values.push(value)
    value
  end

  def pop
    @values.pop
  end

  def size
    @values.size
  end
end

