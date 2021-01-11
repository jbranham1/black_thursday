require './test/test_helper'
require './lib/customer'

class CustomerTest < Minitest::Test
  def setup
    @repository = mock
    @customer = Customer.new(customer_data, @repository)
  end

  def customer_data
    {
      id: 6,
      first_name: 'Joan',
      last_name: 'Clarke',
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def new_values
    {
      first_name: 'Chandler',
      last_name: 'Bing'
    }
  end

  def test_it_exists
    assert_instance_of Customer, @customer
  end

  def test_it_has_readable_attributes
    assert_equal 6, @customer.id
    assert_equal 'Joan', @customer.first_name
    assert_equal 'Clarke', @customer.last_name
    assert_instance_of Time, @customer.created_at
    assert_instance_of Time, @customer.updated_at
    assert_equal @repository, @customer.repository
  end

  def test_can_update_certain_attributes
    original_updated_at = @customer.updated_at
    @customer.update(new_values)

    assert_equal 'Chandler', @customer.first_name
    assert_equal 'Bing', @customer.last_name
    assert_equal false, (original_updated_at == @customer.updated_at)
  end
end
