require './test/test_helper'
require './lib/sales_engine'
require './lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def setup
    files = {
      items: './data/items.csv',
      merchants: './data/merchants.csv'
    }
    sales_engine = SalesEngine.new(files)
    @analyst = sales_engine.analyst
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @analyst
  end

  def test_average_items_per_merchant
    assert_equal 2.88, @analyst.average_items_per_merchant
  end
end
