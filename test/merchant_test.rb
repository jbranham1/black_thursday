require './test/test_helper'
require './lib/merchant'

class MerchantTest < Minitest::Test
  def setup
    @repository = mock
    @merchant = Merchant.new({ id: 5, name: 'Turing School' }, @repository)
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
end
