require './test/test_helper'
require 'bigdecimal'
require './lib/merchant'
require './lib/item'
require './lib/invoice'

class MerchantTest < Minitest::Test
  def setup
    @repository = mock
    @merchant = Merchant.new(
      {
        id: 5,
        name: 'Turing School',
        created_at: Time.new(2021, 1, 1, 8, 0, 0)
      }, @repository)
  end

  def create_item
    Item.new(item_data, mock)
  end

  def create_invoice
    Invoice.new(invoice_data, mock)
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

  def test_it_exists
    assert_instance_of Merchant, @merchant
  end

  def test_it_has_readable_attributes
    assert_equal 5, @merchant.id
    assert_equal 'Turing School', @merchant.name
    assert_equal @repository, @merchant.repository
    assert_instance_of Time, @merchant.created_at
  end

  def test_update
    @merchant.update(name: 'Turing School Updated')

    assert_equal 'Turing School Updated', @merchant.name
  end

  def test_can_retrieve_items
    item = create_item
    @repository
      .expects(:items_by_merchant_id)
      .with(@merchant.id)
      .returns([item])

    assert_equal [item], @merchant.items
  end

  def test_can_retrieve_invoices
    invoice = create_invoice
    @repository
      .expects(:invoices_by_merchant_id)
      .with(@merchant.id)
      .returns([invoice])

    assert_equal [invoice], @merchant.invoices
  end

  def test_has_one_item
    item = create_item
    @repository
      .expects(:items_by_merchant_id)
      .with(@merchant.id)
      .returns([item])

    assert_equal true, @merchant.has_one_item?
  end
end
