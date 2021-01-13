require './test/test_helper'
require './lib/mathable'

class MockRepository
  include Mathable
end

class MathableTest < Minitest::Test
  def setup
    @repo = MockRepository.new
  end

  def test_it_exists
    assert_instance_of MockRepository, @repo
  end

  def test_average
    array = [1.00, 2.50, 3.75]

    assert_equal 2.42, @repo.average(array)
  end

  def test_standard_deviation
    array = [1.00, 2.50, 3.75]
    mean = @repo.average(array)

    assert_equal 1.38, @repo.standard_deviation(array, mean)
  end

  def test_percentage
    assert_equal 50.00, @repo.percentage(2, 4)
  end
end
