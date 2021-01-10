require './test/test_helper'
require './lib/customer'

class CustomerTest < Minitest::Test
  def setup
    @repository = mock
    @customer = Customer.new(customer_data, @repository)
  end

  def customer_data
    {
      :id => 6,
      :first_name => 'Joan',
      :last_name => 'Clarke',
      :created_at => Time.now,
      :updated_at => Time.now
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
end
