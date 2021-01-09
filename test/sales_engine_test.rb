require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def setup
    files = {
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv'
    }

    @engine = SalesEngine.from_csv(files)
  end

  def test_is_created_from_csv_files
    assert_instance_of ItemRepository, @engine.item_repository
    assert_instance_of MerchantRepository, @engine.merchant_repository
    assert_instance_of InvoiceRepository, @engine.invoice_repository
  end

  def test_can_create_a_sales_analyst
    assert_instance_of SalesAnalyst, @engine.analyst
  end

  def test_can_find_items_by_merchant_id
    merchant_id = 12_334_159

    result = @engine.items_by_merchant_id(merchant_id)

    assert_instance_of Array, result
    assert_equal true, (result.all? { |object| object.is_a? Item })
  end
end
