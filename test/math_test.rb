require './test/test_helper'
require './lib/math'

class MockRepository
  include Math
end

class MathTest < Minitest::Test
  def setup
    @repo = MockRepository.new
  end

  def test_it_exists
    assert_instance_of MockRepository, @repo
  end

  def test_sum
    array = [1.00, 2.50, 3.75]

    assert_equal 7.25, @repo.sum(array)
  end

  def test_average
    array = [1.00, 2.50, 3.75]

    assert_equal 2.42, @repo.average(array, 2)
  end

  def test_standard_deviation
    array = [1.00, 2.50, 3.75]
    mean = @repo.average(array, 2)

    assert_equal 1.38, @repo.standard_deviation(array, mean)
  end

  def test_average_by
    total_sum = 50.00
    length = 7.00

    assert_equal 7.14, @repo.average_by(total_sum, length, 2)
  end
end
