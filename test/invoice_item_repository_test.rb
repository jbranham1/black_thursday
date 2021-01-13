require './test/test_helper'
require 'csv'
require 'bigdecimal'
require './lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
  def setup
    filepath = './data/test_invoice_item.csv'
    @engine = mock
    @repo = InvoiceItemRepository.new(filepath, @engine)
  end

  def sorted_actual_ids(records)
    records.map(&:id).sort
  end

  def attributes
    {
      id: 6,
      item_id: 7,
      invoice_id: 8,
      quantity: 1,
      unit_price: BigDecimal(1099, 4),
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def test_it_exists
    assert_instance_of InvoiceItemRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end

  def test_build_invoice_items
    assert_equal 5, @repo.all.count
  end

  def test_invoice_item_from
    assert_instance_of InvoiceItem, @repo.invoice_item_from(attributes)
  end

  def test_can_return_all_records
    all_records = @repo.all

    assert_instance_of Array, all_records
    assert_equal true, (all_records.all? { |record| record.is_a? InvoiceItem })
  end

  def test_can_find_by_id
    invoice_item = @repo.find_by_id(1)

    assert_equal 1, invoice_item.id
    assert_nil @repo.find_by_id(-1)
  end

  def test_can_find_all_by_item_id
    expected_ids = [1, 3]

    actual_returned_records = @repo.find_all_by_item_id(263_519_844)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_item_id
    assert_equal [], @repo.find_all_by_item_id(-1)
  end

  def test_can_find_all_by_invoice_id
    expected_ids = [1, 2]

    actual_returned_records = @repo.find_all_by_invoice_id(1)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_invoice_id
    assert_equal [], @repo.find_all_by_invoice_id(-1)
  end

  def test_find_all_by_invoice_ids
    expected_ids = [3, 4, 5]

    actual_returned_records = @repo.find_all_by_invoice_ids([2, 3])
    assert_equal expected_ids, sorted_actual_ids(actual_returned_records)
  end

  def test_create_invoice_item
    @repo.create(attributes)

    assert_equal 6, @repo.all.count
    assert_instance_of InvoiceItem, @repo.all.last
    assert_equal 6, @repo.all.last.id
  end

  def test_can_update_an_invoice_item
    invoice_item_to_update = @repo.find_by_id(1)
    original_updated_at = invoice_item_to_update.updated_at
    attributes = { quantity: 2, unit_price: BigDecimal(1299, 4) }

    @repo.update(1, attributes)

    assert_equal 2, invoice_item_to_update.quantity
    assert_equal BigDecimal(1299, 4), invoice_item_to_update.unit_price
    assert_equal false, (original_updated_at ==
      invoice_item_to_update.updated_at)
  end

  def test_can_delete_invoice
    @repo.delete(1)

    assert_equal 4, @repo.all.count
    assert_nil @repo.find_by_id(1)
  end

  def test_invoice_total
    assert_equal 2780.91, @repo.invoice_total(1)
  end

  def test_invoice_total_with_no_invoices
    assert_equal 0, @repo.invoice_total(-1)
  end
end
