require './test/test_helper'
require 'csv'
require './lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
  def setup
    filepath = './data/test_invoice.csv'
    @engine = mock
    @repo = InvoiceRepository.new(filepath, @engine)
  end

  def sorted_actual_ids(records)
    records.map(&:id).sort
  end

  def attributes
    {
      id: 1,
      customer_id: 2,
      merchant_id: 3,
      status: :pending,
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def test_it_exists
    assert_instance_of InvoiceRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end

  def test_build_invoices
    assert_equal 2, @repo.all.count
  end

  def test_invoice_from
    assert_instance_of Invoice, @repo.invoice_from(attributes)
  end

  def test_can_return_all_records
    all_records = @repo.all

    assert_instance_of Array, all_records
    assert_equal true, (all_records.all? { |record| record.is_a? Invoice })
  end

  def test_can_find_by_id
    invoice = @repo.find_by_id(1)

    assert_equal 1, invoice.id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_all_by_customer_id
    expected_ids = [1, 2]

    actual_returned_records = @repo.find_all_by_customer_id(1)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_customer_id
    assert_equal [], @repo.find_all_by_customer_id(2)
  end

  def test_can_find_all_by_merchant_id
    expected_ids = [1]

    actual_returned_records = @repo.find_all_by_merchant_id(12_335_938)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_merchant_id
    assert_equal [], @repo.find_all_by_merchant_id(1)
  end

  def test_can_find_all_by_status
    expected_ids = [1]

    actual_returned_records = @repo.find_all_by_status(:pending)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_status
    assert_equal [], @repo.find_all_by_status(:test)
  end

  def test_can_group_by_day
    assert_equal Hash, @repo.group_by_day.class
    assert_equal 2, @repo.group_by_day.count
    assert_equal ["Saturday","Friday"], @repo.group_by_day.keys
  end

  def test_create_invoice
    @repo.create(attributes)

    assert_equal 3, @repo.all.count
    assert_instance_of Invoice, @repo.all.last
    assert_equal 3, @repo.all.last.id
  end

  def test_can_update_an_invoice
    invoice_to_update = @repo.find_by_id(1)
    original_updated_at = invoice_to_update.updated_at
    attributes = { status: 'sold' }
    @repo.update(1, attributes)

    assert_equal 'sold', invoice_to_update.status
    assert_equal false, (original_updated_at == invoice_to_update.updated_at)
  end

  def test_can_delete_invoice
    @repo.delete(1)

    assert_equal 1, @repo.all.count
    assert_nil @repo.find_by_id(1)
  end
end
