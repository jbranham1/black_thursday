require './test/test_helper'
require './lib/transaction'

class TransactionTest < Minitest::Test
  def setup
    @repository = mock
    @transaction = Transaction.new(
      {
        id: 1,
        invoice_id: 2,
        credit_card_number: '4242424242424242',
        credit_card_expiration_date: '0220',
        result: 'success',
        created_at: Time.now,
        updated_at: Time.now
      }, @repository
    )
  end

  def new_values
    {
      credit_card_number: '2',
      credit_card_expiration_date: '0110',
      result: 'fail'
    }
  end

  def test_it_exists
    assert_instance_of Transaction, @transaction
  end

  def test_readable_attributes
    assert_equal 1, @transaction.id
    assert_equal 2, @transaction.invoice_id
    assert_equal '4242424242424242', @transaction.credit_card_number
    assert_equal '0220', @transaction.credit_card_expiration_date
    assert_equal 'success', @transaction.result
    assert_instance_of Time, @transaction.created_at
    assert_instance_of Time, @transaction.updated_at
    assert_equal @repository, @transaction.repository
  end

  def test_can_update_certain_attributes
    original_updated_at = @transaction.updated_at
    @transaction.update(new_values)

    assert_equal '2', @transaction.credit_card_number
    assert_equal '0110', @transaction.credit_card_expiration_date
    assert_equal 'fail', @transaction.result
    assert_equal false, (original_updated_at == @transaction.updated_at)
  end
end
