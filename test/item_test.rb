require './test/test_helper'
require 'bigdecimal'
require './lib/item'

class ItemTest < Minitest::Test
  def setup
    @repository = mock
    @item = Item.new(
      {
        id: 1,
        name: 'item',
        description: 'You can use it to write things.',
        unit_price: BigDecimal(1099, 4),
        created_at: Time.new(2021, 1, 1, 8, 0, 0),
        updated_at: Time.new(2021, 1, 1, 8, 0, 0),
        merchant_id: 2
      }, @repository
    )
  end

  def test_it_exists
    assert_instance_of Item, @item
  end

  def test_readable_attributes
    assert_equal 1, @item.id
    assert_equal 'item', @item.name
    assert_equal 'You can use it to write things.', @item.description
    assert_equal BigDecimal(1099, 4), @item.unit_price
    assert_instance_of Time, @item.created_at
    assert_instance_of Time, @item.updated_at
    assert_equal 2, @item.merchant_id
    assert_equal @repository, @item.repository
  end

  def test_can_convert_price_to_float
    assert_equal 1099.00, @item.unit_price_to_dollars
  end

  def test_can_update_certain_attributes
    new_values = {
      name: 'Colored item',
      description: 'For when you want a item but need pretty colors.',
      unit_price: BigDecimal(9.99, 4)
    }

    original_updated_at = @item.updated_at
    @item.update(new_values)

    assert_equal new_values[:name], @item.name
    assert_equal new_values[:description], @item.description
    assert_equal new_values[:unit_price], @item.unit_price
    assert_equal false, (original_updated_at == @item.updated_at)
  end

  def test_can_find_invoice_items
    @repository.expects(:invoice_items_by_item).with(@item.id)

    @item.invoice_items
  end

  def test_revenue
    invoice_item1 = mock
    invoice_item1.stubs(:quantity).returns(2)
    invoice_item1.stubs(:unit_price).returns(2.5)
    invoice_item2 = mock
    invoice_item2.stubs(:quantity).returns(5)
    invoice_item2.stubs(:unit_price).returns(1)

    @item
      .expects(:invoice_items)
      .returns([invoice_item1, invoice_item2])

    assert_equal 10, @item.revenue
  end
end
