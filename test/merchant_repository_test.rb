require './test/test_helper'
require 'csv'
require 'bigdecimal'
require './lib/merchant_repository'
require './lib/item'
require './lib/invoice'
require './lib/merchant'

class MerchantRepositoryTest < Minitest::Test
  def setup
    filepath = './data/test_merchant.csv'
    @engine = mock
    @repo = MerchantRepository.new(filepath, @engine)
  end

  def create_item
    Item.new(item_data, mock)
  end

  def create_invoice
    Invoice.new(invoice_data, mock)
  end

  def create_merchant
    Merchant.new(merchant_data, mock)
  end

  def item_data
    {
      id: 1,
      name: 'Pencil',
      description: 'You can use it to write things.',
      unit_price: BigDecimal(1099, 4),
      created_at: Time.new(2021, 1, 1, 8, 0, 0),
      updated_at: Time.new(2021, 1, 1, 8, 0, 0),
      merchant_id: 2
    }
  end

  def invoice_data
    {
      id: 1,
      customer_id: 2,
      merchant_id: 3,
      status: 'pending',
      created_at: Time.new(2021, 1, 1, 8, 0, 0),
      updated_at: Time.new(2021, 1, 1, 8, 0, 0)
    }
  end

  def sorted_actual_ids(merchants)
    merchants.map(&:id).sort
  end

  def test_it_exists
    assert_instance_of MerchantRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end

  def test_build_merchants
    assert_equal 3, @repo.all.count
  end

  def test_can_return_all_items
    all_merchants = @repo.all

    assert_instance_of Array, all_merchants
    assert_equal true, all_merchants.all? do |merchant|
      merchant.is_a?(Merchant)
    end
  end

  def test_can_find_by_id
    merchant = @repo.find_by_id(12_334_105)

    assert_equal 12_334_105, merchant.id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_by_name
    merchant = @repo.find_by_name('Shopin1901')

    assert_equal 'Shopin1901', merchant.name
    assert_nil @repo.find_by_name('Potato')
  end

  def test_can_find_all_by_name
    expected_ids = [12_334_105]
    actual = @repo.find_all_by_name('Shopin1901')

    assert_equal expected_ids, sorted_actual_ids(actual)
  end

  def test_can_find_nothing_when_searching_by_name
    assert_equal [], @repo.find_all_by_name('doo-doo')
  end

  def test_create_merchant
    attributes = { name: 'Turing School' }
    @repo.create(attributes)

    assert_instance_of Merchant, @repo.all.last
    assert_equal 4, @repo.all.count
    assert_equal 12_345_679, @repo.all.last.id
  end

  def test_can_update_merchant
    merchant = @repo.find_by_id(12_334_105)
    attributes = { name: 'Turing School Updated' }
    @repo.update(12_334_105, attributes)

    assert_equal 'Turing School Updated', merchant.name
  end

  def test_can_delete_merchant
    @repo.delete(12_334_105)

    assert_equal 2, @repo.all.count
    assert_nil @repo.find_by_id(12_334_105)
  end

  def test_items_by_merchant_id
    item = create_item
    merchant_id = 1
    @engine
      .expects(:items_by_merchant_id)
      .with(merchant_id)
      .returns([item])

    assert_equal [item], @repo.items_by_merchant_id(merchant_id)
  end

  def test_invoices_by_merchant_id
    invoice = create_invoice
    merchant_id = 12_335_938
    @engine
      .expects(:invoices_by_merchant_id)
      .with(merchant_id)
      .returns([invoice])

    assert_equal [invoice], @repo.invoices_by_merchant_id(merchant_id)
  end

  def test_can_return_merchant_ids
    expected = [12_334_105, 12_334_112, 12_345_678]

    assert_equal expected, @repo.merchant_ids
  end

  def test_merchants_with_ids
    expected_ids = [12_334_105, 12_334_112]
    result = @repo.merchants_with_ids(expected_ids)

    assert_equal 2, result.length
    assert_equal expected_ids, sorted_actual_ids(result)
  end

  def test_merchants_with_pending_invoices
    # TODO: How do we test this?
  end

  def test_best_item_for_merchant
    merchant_id = 12_335_938
    merchant = 'my merchant'
    @repo
      .expects(:find_by_id)
      .with(merchant_id)
      .returns(merchant)

    merchant.expects(:best_item).returns('my item')
    assert_equal 'my item', @repo.best_item_for_merchant(merchant_id)
  end

  def test_most_sold_item_for_merchant
    merchant_id = 12_335_938
    merchant = 'my merchant'
    @repo
      .expects(:find_by_id)
      .with(merchant_id)
      .returns(merchant)

    merchant.expects(:most_sold_item).returns('my item')
    assert_equal 'my item', @repo.most_sold_item_for_merchant(merchant_id)
  end
end
