require './test/test_helper'
require './lib/invoice_item'
require 'bigdecimal'

class InvoiceItemTest < Minitest::Test
  def setup
    @repository = mock
    @invoice_item = invoice_item
  end

  def invoice_item
    InvoiceItem.new(
      {
        id: 6,
        item_id: 7,
        invoice_id: 8,
        quantity: 1,
        unit_price: BigDecimal(1099, 4),
        created_at: Time.now,
        updated_at: Time.now
      }, @repository
    )
  end

  def test_it_exists
    assert_instance_of InvoiceItem, @invoice_item
  end

  def test_readable_attributes
    assert_equal 6, @invoice_item.id
    assert_equal 7, @invoice_item.item_id
    assert_equal 8, @invoice_item.invoice_id
    assert_equal 1, @invoice_item.quantity
    assert_equal BigDecimal(1099, 4), @invoice_item.unit_price
    assert_instance_of Time, @invoice_item.created_at
    assert_instance_of Time, @invoice_item.updated_at
    assert_equal @repository, @invoice_item.repository
  end

  def test_can_update_certain_attributes
    original_updated_at = @invoice_item.updated_at
    @invoice_item.update(quantity: 2, unit_price: BigDecimal(1299, 4))

    assert_equal 2, @invoice_item.quantity
    assert_equal BigDecimal(1299, 4), @invoice_item.unit_price
    assert_equal false, (original_updated_at == @invoice_item.updated_at)
  end

  def test_can_convert_price_to_float
    assert_equal 1099.00, @invoice_item.unit_price_to_dollars
  end
end
