require './test/test_helper'
require './lib/merchant'

class MerchantTest < Minitest::Test
  def test_it_exists
    merchant = Merchant.new({ id: 5, name: 'Turing School' })

    assert_instance_of Merchant, merchant
  end

  def test_it_has_readable_attributes
    merchant = Merchant.new({ id: 5, name: 'Turing School' })

    assert_equal 5, merchant.id
    assert_equal 'Turing School', merchant.name
  end

  def test_update
    merchant = Merchant.new({ id: 5, name: 'Turing School' })
    merchant.update({ name: 'Turing School Updated' })

    assert_equal 'Turing School Updated', merchant.name
  end
end
