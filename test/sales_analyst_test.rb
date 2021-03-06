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
    assert_equal 712.14, @analyst.average_invoices_per_day
  end

  def test_average_invoices_per_day_standard_deviation
    assert_equal 18.07, @analyst.average_invoices_per_day_standard_deviation
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
    assert_equal 12_334_634, first.id

    assert_instance_of Merchant, last
    assert_equal 12_335_747, last.id
  end

  def test_merchants_with_revenue
    result = @analyst.merchants_with_revenue

    assert_equal true, (result.keys.all? { |object| object.is_a? Merchant })
    assert_equal true, (result.values.all? { |object| object.is_a? BigDecimal })
  end

  def test_merchants_sorted_by_revenue
    expected = @analyst.merchants_sorted_by_revenue
    first = expected.first[0]

    assert_instance_of Merchant, first
    assert_equal 12_334_634, first.id
  end

  def test_merchants_with_only_one_item
    assert_equal Array, @analyst.merchants_with_only_one_item.class
    assert_equal 243, @analyst.merchants_with_only_one_item.count
  end

  def test_merchants_with_only_one_item_registered_in_month
    merch = @analyst.merchants_with_only_one_item_registered_in_month('March')

    assert_equal Array, merch.class
    assert_equal 21, merch.count
  end

  def test_revenue_by_merchant
    assert_instance_of BigDecimal, @analyst.revenue_by_merchant(12_334_194)
  end

  def test_merchants_with_pending_invoices
    result = @analyst.merchants_with_pending_invoices

    assert_equal 467, result.length
    assert_equal true, (result.all? { |object| object.is_a? Merchant })
  end

  def test_most_sold_item_for_merchant
    result = @analyst.most_sold_item_for_merchant(12_334_105)

    assert_equal true, (result.all? { |object| object.is_a? Item })
    assert_equal 263_396_209, result.first.id
  end

  def test_best_item_for_merchant
    result = @analyst.best_item_for_merchant(12_334_105)

    assert_instance_of Item, result
    assert_equal 263_396_209, result.id
  end
end
