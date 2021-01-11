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

  def new_values
    {
      first_name: 'Chandler',
      last_name: 'Bing'
    }
  end

  def test_it_exists
    assert_instance_of CustomerRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end

  def test_build_customers
    assert_equal 2, @repo.all.count
  end

  def test_customer_from
    assert_instance_of Customer, @repo.customer_from(attributes)
  end

  def test_can_return_all_records
    all_records = @repo.all

    assert_instance_of Array, all_records
    assert_equal true, (all_records.all? { |record| record.is_a? Customer })
  end

  def test_can_find_by_id
    assert_equal 1, @repo.find_by_id(1).id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_all_by_first_name_substring
    expected_ids = [1]

    actual_returned_items = @repo.find_all_by_first_name('Joey')
    assert_equal expected_ids, sorted_actual_ids(actual_returned_items)
  end

  def test_can_find_nothing_when_searching_by_first_name_substring
    assert_equal [], @repo.find_all_by_first_name('doo-doo')
  end

  def test_can_find_all_by_last_name_substring
    expected_ids = [2]

    actual_returned_items = @repo.find_all_by_last_name('Osinski')
    assert_equal expected_ids, sorted_actual_ids(actual_returned_items)
  end

  def test_can_find_nothing_when_searching_by_last_name_substring
    assert_equal [], @repo.find_all_by_last_name('doo-doo')
  end

  def test_create_customer
    @repo.create(attributes)

    assert_equal 3, @repo.all.count
    assert_instance_of Customer, @repo.all.last
    assert_equal 3, @repo.all.last.id
  end

  def test_can_update_a_customer
    customer_to_update = @repo.find_by_id(1)
    original_updated_at = customer_to_update.updated_at
    @repo.update(1, new_values)
    updated_time = customer_to_update.updated_at

    assert_equal 'Chandler', customer_to_update.first_name
    assert_equal 'Bing', customer_to_update.last_name
    assert_equal false, (original_updated_at == updated_time)
  end

  def test_can_delete_customer
    @repo.delete(1)

    assert_equal 1, @repo.all.count
    assert_nil @repo.find_by_id(1)
  end
end
