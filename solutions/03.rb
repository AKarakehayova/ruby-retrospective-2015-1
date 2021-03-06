class Integer
  def is_prime?
    return false if self <= 1
    (2...self).each do |divisor|
      return false if self % divisor == 0
    end
    true
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    count, numerator, denominator, direction = 0, 1, 1, false
    while count < @limit
      if numerator.gcd(denominator) == 1
        element = numerator / denominator.to_r
        count += 1
        yield element
      end
      numerator, denominator, direction = next_values(numerator, denominator, direction)
    end
  end

  def next_values(numerator, denominator, direction)
    if direction && numerator > 1
      numerator -= 1
      denominator += 1
    elsif direction && numerator <= 1
      direction, numerator = false, 1
      denominator += 1
    elsif (not direction) && denominator > 1
      numerator += 1
      denominator -= 1
    elsif (not direction) && denominator <= 1
      direction, denominator = true, 1
      numerator += 1
    end
    return numerator, denominator, direction
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    count, current = 0, 2
    while count < @limit
      if prime?(current)
        yield current
        count += 1
      end
      current += 1
    end
  end

  def prime?(number)
    (2...number).each do |divisor|
      return false if (number % divisor) == 0
    end
    true
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first:1, second:1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    count = 0
    while count < @limit
      yield @first
      count += 1
      @second, @first = @second + @first, @second
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    rational = RationalSequence.new(n).partition do |number|
      number.numerator.is_prime? or number.denominator.is_prime?
    end
    group_one = rational[0].reduce(1, :*)
    group_two = rational[1].reduce(1, :*)
    group_one / group_two
  end

  def product(group_one, group_two)
    product_one = group_one.inject(:*).to_r
    product_one = 1 if product_one == 0
    product_two = group_two.inject(:*).to_r
    product_one / product_two
  end

  def aimless(n)
    prime_numbers = PrimeSequence.new(n).to_a
    current, index = 0, 0
    prime_numbers[n] = 1 if n.odd?
    length = prime_numbers.length
    array = []
    while current != length
      array[index] = prime_numbers[current] / prime_numbers[current + 1].to_r
      current += 2
      index += 1
    end
    array.inject(:+).to_r
  end

  def worthless(n)
    number = FibonacciSequence.new(n).to_a.last
    sum, count = 0, 1
    while (sum <= number)
      array = RationalSequence.new(count).to_a
      sum = array.inject(:+)
      count += 1
    end
    array.pop
    array
  end
end
