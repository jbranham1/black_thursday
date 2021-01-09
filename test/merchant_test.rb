require './test/test_helper'
require 'bigdecimal'
require './lib/merchant'
require './lib/item'

class MerchantTest < Minitest::Test
  def setup
    @repository = mock
    @merchant = Merchant.new({ id: 5, name: 'Turing School' }, @repository)
  end

  def create_item
    Item.new(
      {
        id: 1,
        name: 'Pencil',
        description: 'You can use it to write things.',
        unit_price: BigDecimal(1099, 4),
        created_at: Time.new(2021, 1, 1, 8, 0, 0),
        updated_at: Time.new(2021, 1, 1, 8, 0, 0),
        merchant_id: 2
      }, mock
    )
  end

  def test_it_exists
    assert_instance_of Merchant, @merchant
  end

  def test_it_has_readable_attributes
    assert_equal 5, @merchant.id
    assert_equal 'Turing School', @merchant.name
    assert_equal @repository, @merchant.repository
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
end
