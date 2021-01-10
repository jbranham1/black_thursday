require './test/test_helper'
require 'csv'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test
  def setup
    filepath = './data/test_transaction.csv'
    @engine = mock
    @repo = TransactionRepository.new(filepath, @engine)
  end

  def sorted_actual_ids(records)
    records.map(&:id).sort
  end

  def attributes
    {
      id: 1,
      transaction_id: 2,
      credit_card_number: '4242424242424242',
      credit_card_expiration_date: '0220',
      result: 'success',
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def new_values
    {
      credit_card_number: '0101010101',
      credit_card_expiration_date: '0110',
      result: 'fail'
    }
  end

  def test_it_exists
    assert_instance_of TransactionRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end

  def test_build_transactions
    assert_equal 2, @repo.all.count
  end

  def test_transaction_from
    assert_instance_of Transaction, @repo.transaction_from(attributes)
  end

  def test_can_return_all_records
    all_records = @repo.all

    assert_instance_of Array, all_records
    assert_equal true, (all_records.all? { |record| record.is_a? Transaction })
  end

  def test_can_find_by_id
    assert_equal 1, @repo.find_by_id(1).id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_all_by_invoice_id
    actual_returned_records = @repo.find_all_by_invoice_id(2179)
    assert_equal [1], sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_invoice_id
    assert_equal [], @repo.find_all_by_invoice_id(1)
  end

  def test_can_find_all_by_credit_card_number
    number = '4068631943231473'
    actual_returned_records = @repo.find_all_by_credit_card_number(number)
    assert_equal [1], sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_credit_card_number
    assert_equal [], @repo.find_all_by_credit_card_number('1')
  end

  def test_can_find_all_by_result
    actual_returned_records = @repo.find_all_by_result(:success)
    assert_equal [1, 2], sorted_actual_ids(actual_returned_records)
  end

  def test_can_find_nothing_when_searching_all_by_result
    assert_equal [], @repo.find_all_by_result(:fail)
  end

  def test_create_transaction
    @repo.create(attributes)

    assert_equal 3, @repo.all.count
    assert_instance_of Transaction, @repo.all.last
    assert_equal 3, @repo.all.last.id
  end

  def test_can_update_an_transaction
    transaction_to_update = @repo.find_by_id(1)
    original_updated_at = transaction_to_update.updated_at
    @repo.update(1, new_values)
    updated_time = transaction_to_update.updated_at
    
    assert_equal '0101010101', transaction_to_update.credit_card_number
    assert_equal '0110', transaction_to_update.credit_card_expiration_date
    assert_equal 'fail', transaction_to_update.result
    assert_equal false, (original_updated_at == updated_time)
  end

  def test_can_delete_transaction
    @repo.delete(1)

    assert_equal 1, @repo.all.count
    assert_nil @repo.find_by_id(1)
  end
end
