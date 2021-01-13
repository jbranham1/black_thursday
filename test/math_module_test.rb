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
    set = [1.00, 2.50, 3.75]

    assert_equal 7.25, @repo.sum(set)
  end

  def test_average
    set = [1.00, 2.50, 3.75]

    assert_equal 2.42, @repo.average(set, 2)
  end

  def test_standard_deviation
    set = [1.00, 2.50, 3.75]
    mean = @repo.average(set, 2)

    assert_equal 1.38, @repo.standard_deviation(set, mean)
  end
end
