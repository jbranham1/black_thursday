require './test/test_helper'
require './lib/sales_engine'
require './lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def setup
    files = {
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv'
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

  def test_average_items_per_merchant_standard_deviation
    assert_equal 3.26, @analyst.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    result = @analyst.merchants_with_high_item_count

    assert_instance_of Array, result
    assert_equal true, (result.all? { |object| object.is_a? Merchant })
  end

  def test_can_group_items_by_merchant
    result = @analyst.items_by_merchant

    assert_equal true, (result.keys.all? { |object| object.is_a? Merchant })
    assert_equal true, (result.values.all? { |object| object.is_a? Array })
  end

  def test_can_find_average_price_for_merchant
    result = @analyst.average_item_price_for_merchant(12_334_159)

    assert_instance_of BigDecimal, result
  end

  def test_can_find_golden_items
    skip
    @result = @analyst.golden_items

    assert_instance_of Array, @result
    assert_equal true, (result.all? { |object| object.is_a? Item })
  end
end
