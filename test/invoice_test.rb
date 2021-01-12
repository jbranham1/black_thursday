require './test/test_helper'
require './lib/invoice'

class InvoiceTest < Minitest::Test
  def setup
    @repository = mock
    @invoice = Invoice.new(
      {
        id: 1,
        customer_id: 2,
        merchant_id: 3,
        status: 'pending',
        created_at: Time.new(2021, 1, 1, 8, 0, 0),
        updated_at: Time.new(2021, 1, 1, 8, 0, 0)
      }, @repository
    )
  end

  def test_it_exists
    assert_instance_of Invoice, @invoice
  end

  def test_readable_attributes
    assert_equal 1, @invoice.id
    assert_equal 2, @invoice.customer_id
    assert_equal 3, @invoice.merchant_id
    assert_equal 'pending', @invoice.status
    assert_instance_of Time, @invoice.created_at
    assert_instance_of Time, @invoice.updated_at
    assert_equal @repository, @invoice.repository
  end

  def test_can_update_certain_attributes
    original_updated_at = @invoice.updated_at
    @invoice.update(status: 'sold')

    assert_equal 'sold', @invoice.status
    assert_equal false, (original_updated_at == @invoice.updated_at)
  end

  def test_can_find_transactions
    @repository
      .expects(:transactions_for_invoice)
      .with(@invoice.id)

    @invoice.transactions
  end

  # def test_paid_in_full
  # TODO: how do we test this?
  #   @repository
  #     .expects(:transactions_for_invoice)
  #     .with(@invoice.id)
  #     .returns([t1, t2])

  #   assert_equal ___, @invoice.paid_in_full?
  # end
end
