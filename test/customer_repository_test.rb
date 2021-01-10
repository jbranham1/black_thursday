require './test/test_helper'
require 'csv'
require './lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
  def setup
    filepath = './data/test_customer.csv'
    @engine = mock
    @repo = CustomerRepository.new(filepath, @engine)
  end

  def sorted_actual_ids(records)
    records.map(&:id).sort
  end

  def attributes
    {
      id: 6,
      first_name: 'Joan',
      last_name: 'Clarke',
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def test_it_exists
    assert_instance_of CustomerRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end
end
