require './test/test_helper'
require './lib/sales_engine'
require './lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def setup
    files = {
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv',
      customers: './data/customers.csv'
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
    result = @analyst.average_item_price_for_merchant(12_334_105)

    assert_instance_of BigDecimal, result
  end

  def test_average_average_price_per_merchant
    result = @analyst.average_average_price_per_merchant

    assert_instance_of BigDecimal, result
  end

  def test_can_find_golden_items
    result = @analyst.golden_items

    assert_instance_of Array, result
    assert_equal true, (result.all? { |object| object.is_a? Item })
  end

  def test_average_invoices_per_merchant
    assert_equal 10.49, @analyst.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, @analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    result = @analyst.top_merchants_by_invoice_count

    assert_instance_of Array, result
    assert_equal true, (result.all? { |object| object.is_a? Merchant })
    assert_equal 12, result.length
  end

  def test_bottom_merchants_by_invoice_count
    result = @analyst.bottom_merchants_by_invoice_count

    assert_instance_of Array, result
    assert_equal true, (result.all? { |object| object.is_a? Merchant })
    assert_equal 4, result.length
  end

  def test_average_invoices_per_day
    assert_equal 712, @analyst.average_invoices_per_day
  end

  def test_average_invoices_per_day_standard_deviation
    assert_equal 18.06, @analyst.average_invoices_per_day_standard_deviation
  end

  def test_top_days_by_invoice_count
    result = @analyst.top_days_by_invoice_count
    assert_equal ['Wednesday'], result
    assert_equal 1, result.length
  end

  def test_percentage_of_invoice_status
    assert_equal 29.55, @analyst.invoice_status(:pending)
  end

  def test_invoice_paid_in_full
    assert_equal true, @analyst.invoice_paid_in_full?(2179)
  end

  def test_invoice_not_paid_in_full
    assert_equal false, @analyst.invoice_paid_in_full?(1752)
  end

  def test_invoice_total
    assert_equal 21_067.77, @analyst.invoice_total(1)
  end

  def test_total_revenue_by_date
    date = Time.parse('2009-02-07')

    assert_equal 21_067.77, @analyst.total_revenue_by_date(date)
  end

  def test_top_revenue_earners
    expected = @analyst.top_revenue_earners(10)
    first = expected.first
    last = expected.last

    assert_equal 10, expected.length

    assert_instance_of Merchant, first
    assert_equal 12334634, first.id

    assert_instance_of Merchant, last
    assert_equal 12335747, last.id
  end
end
