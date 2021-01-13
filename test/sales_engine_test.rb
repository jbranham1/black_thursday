require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def setup
    files = {
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv',
      customers: './data/customers.csv'
    }

    @engine = SalesEngine.from_csv(files)
  end

  def test_is_created_from_csv_files
    assert_instance_of ItemRepository, @engine.items
    assert_instance_of MerchantRepository, @engine.merchants
    assert_instance_of InvoiceRepository, @engine.invoices
    assert_instance_of InvoiceItemRepository, @engine.invoice_items
    assert_instance_of TransactionRepository, @engine.transactions
    assert_instance_of CustomerRepository, @engine.customers
  end

  def test_can_create_a_sales_analyst
    assert_instance_of SalesAnalyst, @engine.analyst
  end

  def test_can_find_items_by_merchant_id
    merchant_id = 12_334_159

    result = @engine.items_by_merchant_id(merchant_id)

    assert_instance_of Array, result
    assert_equal false, result.empty?
    assert_equal true, (result.all? { |object| object.is_a? Item })
  end

  def test_merchant_can_have_no_items
    result = @engine.items_by_merchant_id(-1)

    assert_equal true, result.empty?
  end

  def test_can_find_invoices_by_merchant_id
    merchant_id = 12_334_159

    result = @engine.invoices_by_merchant_id(merchant_id)

    assert_instance_of Array, result
    assert_equal false, result.empty?
    assert_equal true, (result.all? { |object| object.is_a? Invoice })
  end

  def test_merchant_can_have_no_invoices
    result = @engine.items_by_merchant_id(-1)

    assert_equal true, result.empty?
  end

  def test_invoice_count_by_status
    assert_equal 1473, @engine.invoice_count_by_status(:pending)
  end

  def test_invoices_by_day
    assert_equal Hash, @engine.invoices_by_day.class
    assert_equal 7, @engine.invoices_by_day.count
  end

  def test_merchants_with_one_item
    assert_equal Array, @engine.merchants_with_one_item.class
    assert_equal 243, @engine.merchants_with_one_item.count
  end

  def test_merchants_with_one_item_in_month
    merchants = @engine.merchants_with_one_item_in_month('March')
    assert_equal Array, merchants.class
    assert_equal 21, merchants.count
  end

  def test_invoice_items_by_item
    item_id = 1
    invoice_item = mock

    @engine
      .invoice_items
      .expects(:find_all_by_item_id)
      .with(item_id)
      .returns(invoice_item)

    assert_equal invoice_item, @engine.invoice_items_by_item(1)
  end

  def test_most_sold_item_for_merchant
    merchant_id = 1
    item = mock
    @engine
      .merchants
      .expects(:most_sold_item_for_merchant)
      .with(merchant_id)
      .returns(item)

    assert_equal item, @engine.most_sold_item_for_merchant(merchant_id)
  end
end
