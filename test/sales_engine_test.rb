require 'minitest/pride'
require 'minitest/autorun'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def test_it_exists
    sales_engine = SalesEngine.new(data)

    assert_instance_of SalesEngine, sales_engine
  end
end
