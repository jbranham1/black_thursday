require './test/test_helper'
require 'bigdecimal'
require './lib/item'

class ItemTest < Minitest::Test
  def setup
    @pencil = Item.new(
      id: 1,
      name: 'Pencil',
      description: 'You can use it to write things.',
      unit_price: BigDecimal(1099, 4),
      created_at: Time.new(2021, 1, 1, 8, 0, 0),
      updated_at: Time.new(2021, 1, 1, 8, 0, 0),
      merchant_id: 2
    )
  end

  def test_it_exists
    assert_instance_of Item, @pencil
  end

  def test_readable_attributes
    assert_equal 1, @pencil.id
    assert_equal 'Pencil', @pencil.name
    assert_equal 'You can use it to write things.', @pencil.description
    assert_equal BigDecimal(1099,4), @pencil.unit_price
    assert_instance_of Time, @pencil.created_at
    assert_instance_of Time, @pencil.updated_at
    assert_equal 2, @pencil.merchant_id
  end

  def test_can_convert_price_to_float
    assert_equal 1099.00, @pencil.unit_price_to_dollars
  end

  def test_can_update_certain_attributes
    new_values = {
      name: 'Colored Pencil',
      description: 'For when you want a pencil but need pretty colors.',
      unit_price: BigDecimal(9.99, 4)
    }

    original_updated_at = @pencil.updated_at
    @pencil.update(new_values)

    assert_equal new_values[:name], @pencil.name
    assert_equal new_values[:description], @pencil.description
    assert_equal new_values[:unit_price], @pencil.unit_price
    assert_equal false, (original_updated_at == @pencil.updated_at)
  end
end
