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

  def sort_ids(objects_with_ids)
    objects_with_ids.map do |object|
      object.id
    end.sort
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

  def test_successful_transactions
    result = @engine.transactions_with_result(:success)

    assert_equal false, result.empty?
    assert_equal true, (result.all? { |transaction| transaction.result == :success })
  end

  def test_invoice_info_for
    result = @engine.invoice_info_for([4, 11])

    assert_equal 4, result.length
    assert_equal [21, 22, 54, 55], sort_ids(result)
  end

# id,item_id,invoice_id,quantity,unit_price,created_at,updated_at
# 21,263566314,4,2,42203,2012-03-27 14:54:10 UTC,2012-03-27 14:54:10 UTC
# 22,263546142,4,3,37333,2012-03-27 14:54:10 UTC,2012-03-27 14:54:10 UTC
# 54,263535944,11,7,62086,2012-03-27 14:54:10 UTC,2012-03-27 14:54:10 UTC
# 55,263397059,11,2,40187,2012-03-27 14:54:10 UTC,2012-03-27 14:54:10 UTC
end
