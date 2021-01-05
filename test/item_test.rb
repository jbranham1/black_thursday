require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require './lib/item'

class ItemTest < Minitest::Test
  def setup
    @pencil = Item.new(
      id: 1,
      name: 'Pencil',
      description: 'You can use it to write things.',
      unit_price: BigDecimal(10.99, 4),
      created_at: Time.now,
      updated_at: Time.now,
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
    assert_equal BigDecimal(10.99, 4), @pencil.unit_price
    assert_instance_of Time, @pencil.created_at
    assert_instance_of Time, @pencil.updated_at
    assert_equal 2, @pencil.merchant_id
  end

  def test_can_convert_price_to_float
    assert_equal 10.99, @pencil.unit_price_to_dollars
  end
end
