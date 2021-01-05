require 'minitest/pride'
require 'minitest/autorun'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def test_it_exists
    files = {
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    }
    sales_engine = SalesEngine.new(files)

    assert_instance_of SalesEngine, sales_engine
  end

  def test_from_csv
    files = {
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    }
    items = ""
    merchants = ""
    sales_engine = SalesEngine.from_csv(files)
    assert_equal items, sales_engine.items
    assert_equal merchants, sales_engine.merchants
  end
end
