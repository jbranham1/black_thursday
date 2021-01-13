require './test/test_helper'
require 'bigdecimal'
require './lib/merchant'
require './lib/item'
require './lib/invoice'

class MerchantTest < Minitest::Test
  def setup
    @repository = mock
    @merchant = Merchant.new(
      {
        id: 5,
        name: 'Turing School',
        created_at: Time.new(2021, 1, 1, 8, 0, 0)
      }, @repository
    )
  end

  def create_item
    Item.new(item_data, mock)
  end

  def create_invoice(data)
    Invoice.new(data, mock)
  end

  def item_data
    {
      id: 1,
      name: 'Pencil',
      description: 'You can use it to write things.',
      unit_price: BigDecimal(1099, 4),
      created_at: Time.new(2021, 1, 1, 8, 0, 0),
      updated_at: Time.new(2021, 1, 1, 8, 0, 0),
      merchant_id: 2
    }
  end

  def pending_invoice_data
    {
      id: 1,
      customer_id: 2,
      merchant_id: 3,
      status: 'pending',
      created_at: Time.new(2021, 1, 1, 8, 0, 0),
      updated_at: Time.new(2021, 1, 1, 8, 0, 0)
    }
  end

  def shipped_invoice_data
    {
      id: 1,
      customer_id: 2,
      merchant_id: 3,
      status: 'shipped',
      created_at: Time.new(2021, 1, 1, 8, 0, 0),
      updated_at: Time.new(2021, 1, 1, 8, 0, 0)
    }
  end

  def mock_pending_invoice
    pending_invoice = mock
    pending_invoice.stubs(:paid_in_full?).returns(false)

    pending_invoice
  end

  def mock_shipped_invoice
    shipped_invoice = mock
    shipped_invoice.stubs(:paid_in_full?).returns(true)

    shipped_invoice
  end

  def test_it_exists
    assert_instance_of Merchant, @merchant
  end

  def test_it_has_readable_attributes
    assert_equal 5, @merchant.id
    assert_equal 'Turing School', @merchant.name
    assert_equal @repository, @merchant.repository
    assert_instance_of Time, @merchant.created_at
  end

  def test_update
    @merchant.update(name: 'Turing School Updated')

    assert_equal 'Turing School Updated', @merchant.name
  end

  def test_can_retrieve_items
    item = create_item
    @repository
      .expects(:items_by_merchant_id)
      .with(@merchant.id)
      .returns([item])

    assert_equal [item], @merchant.items
  end

  def test_can_retrieve_invoices
    pending_invoice = create_invoice(pending_invoice_data)
    shipped_invoice = create_invoice(shipped_invoice_data)
    @repository
      .expects(:invoices_by_merchant_id)
      .with(@merchant.id)
      .returns([pending_invoice, shipped_invoice])

    assert_equal [pending_invoice, shipped_invoice], @merchant.invoices
  end

  def test_pending_invoices
    pending_invoice = mock_pending_invoice
    shipped_invoice = mock_shipped_invoice
    @repository
      .expects(:invoices_by_merchant_id)
      .with(@merchant.id)
      .returns([pending_invoice, shipped_invoice])

    assert_equal [pending_invoice], @merchant.pending_invoices
  end

  def test_has_one_item
    itm = create_item
    @repository.expects(:items_by_merchant_id).with(@merchant.id).returns([itm])

    assert_equal true, @merchant.one_item?
  end

  def test_best_item
    item1 = mock
    item1.stubs(:revenue).returns(20)
    item2 = mock
    item2.stubs(:revenue).returns(50)

    @merchant.expects(:items).returns([item1, item2])

    assert_equal item2, @merchant.best_item
  end

  def test_most_sold_item
    item1 = mock
    item1.stubs(:quantity).returns(20)
    item2 = mock
    item2.stubs(:quantity).returns(50)

    @merchant.expects(:items).returns([item1, item2])
    @merchant.expects(:max_quantity).returns(20)
    assert_equal [item2], @merchant.most_sold_item
  end

  def test_most_sold_item_tie
    item1 = mock
    # item1.stubs(:quantity).returns(20)
    item2 = mock
    # item2.stubs(:quantity).returns(20)
    @merchant.expects(:max_quantity).returns(20)
    @merchant.expects(:items).returns([item1, item2])
    assert_equal [item1, item2], @merchant.most_sold_item
  end

  def test_max_quantity
    item1 = mock
    item1.stubs(:quantity).returns(20)
    item2 = mock
    item2.stubs(:quantity).returns(50)

    @merchant.expects(:items).returns([item1, item2])

    assert_equal item2, @merchant.max_quantity
  end
end
