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
    assert_equal true, (result.all? { |transact| transact.result == :success })
  end

  def test_invoice_info_for
    result = @engine.invoice_info_for([4, 11])

    assert_equal 4, result.length
    assert_equal [21, 22, 54, 55], sort_ids(result)
  end

  def test_invoices_with_status
    result = @engine.invoices_with_status(:pending)

    assert_equal false, result.empty?
    assert_equal 1473, result.length
    assert_equal true, (result.all? { |object| object.is_a? Invoice })
  end

  def test_merchants_with_ids
    expected_ids = [12_334_753, 12_335_938]
    result = @engine.merchants_with_ids(expected_ids)

    assert_equal false, result.empty?
    assert_equal 2, result.length
    assert_equal expected_ids, sort_ids(result)
  end
end
