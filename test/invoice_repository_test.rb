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
    assert_equal 3, @repo.all.count
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
    assert_equal [], @repo.find_all_by_customer_id(-1)
  end

  def test_can_find_all_by_merchant_id
    expected_ids = [1, 3]

    actual_returned_records = @repo.find_all_by_merchant_id(12_335_938)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_merchant_id
    assert_equal [], @repo.find_all_by_merchant_id(-1)
  end

  def test_can_find_all_by_status
    result = @repo.find_all_by_status(:pending)
    assert_equal [1, 3], sorted_actual_ids(result)
  end

  def test_can_find_nothing_when_searching_all_by_status
    assert_equal [], @repo.find_all_by_status(:test)
  end

  def test_can_group_by_day
    result = @repo.group_by_day

    assert_equal Hash, result.class
    assert_equal 3, result.size
    assert_equal %w[Saturday Friday Sunday], result.keys
  end

  def test_create_invoice
    @repo.create(attributes)

    assert_equal 4, @repo.all.count
    assert_instance_of Invoice, @repo.all.last
    assert_equal 4, @repo.all.last.id
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

    assert_equal 2, @repo.all.count
    assert_nil @repo.find_by_id(1)
  end

  def test_transactions_for_invoice
    invoice_id = 1
    @engine
      .expects(:transactions_for_invoice)
      .with(invoice_id)

    @repo.transactions_for_invoice(invoice_id)
  end
end
