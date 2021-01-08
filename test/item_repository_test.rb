require './test/test_helper'
require 'csv'
require 'bigdecimal'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  def setup
    filepath = './data/test_item.csv'
    @engine = mock
    @repo = ItemRepository.new(filepath, @engine)
  end

  def sorted_actual_ids(items)
    items.map(&:id).sort
  end

  def attributes
    {
      id: 1,
      name: 'Pencil',
      description: 'You can use it to write things.',
      unit_price: BigDecimal(10.99, 4),
      created_at: Time.now,
      updated_at: Time.now,
      merchant_id: 2
    }
  end

  def new_values
    {
      name: 'Colored Pencil',
      description: 'For when you want a pencil but need pretty colors.',
      unit_price: BigDecimal(9.99, 4)
    }
  end

  def test_it_exists
    assert_instance_of ItemRepository, @repo
  end

  def test_it_has_readable_attributes
    assert_equal @engine, @repo.engine
  end

  def test_build_items
    assert_equal 2, @repo.all.count
  end

  def test_item_from
    assert_instance_of Item, @repo.item_from(attributes)
  end

  def test_can_return_all_items
    all_items = @repo.all

    assert_instance_of Array, all_items
    assert_equal true, (all_items.all? { |item| item.is_a? Item })
  end

  def test_can_find_by_id
    pencil = @repo.find_by_id(1)

    assert_equal 1, pencil.id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_by_name
    pencil = @repo.find_by_name('Pencil')

    assert_equal 'Pencil', pencil.name
    assert_nil @repo.find_by_name('Potato')
  end

  def test_can_find_all_with_description_substring
    expected_ids = [1, 2]

    actual_returned_items = @repo.find_all_with_description('write')
    assert_equal expected_ids, sorted_actual_ids(actual_returned_items)
  end

  def test_can_find_nothing_when_searching_with_description_substring
    assert_equal [], @repo.find_all_with_description('doo-doo')
  end

  def test_can_find_all_by_price
    expected_ids = [1]

    actual_returned_items = @repo.find_all_by_price(10.99)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_items)
  end

  def test_can_find_nothing_when_searching_all_by_price
    assert_equal [], @repo.find_all_by_price(BigDecimal(0, 4))
  end

  def test_can_find_all_by_price_range
    range = (9.99..39.99)
    expected_ids = [1, 2]

    actual_returned_items = @repo.find_all_by_price_in_range(range)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_items)
  end

  def test_can_find_nothing_when_searching_all_by_price_range
    assert_equal [], @repo.find_all_by_price_in_range((1.99..9.99))
  end

  def test_can_find_all_by_merchant_id
    expected_ids = [1, 2]

    actual_returned_items = @repo.find_all_by_merchant_id(2)
    assert_equal expected_ids, sorted_actual_ids(actual_returned_items)
  end

  def test_can_find_nothing_when_searching_all_by_merchant_id
    assert_equal [], @repo.find_all_by_merchant_id(0)
  end

  def test_create_item
    @repo.create(attributes)

    assert_equal 3, @repo.all.count
    assert_instance_of Item, @repo.all.last
    assert_equal 3, @repo.all.last.id
  end

  def test_can_update_an_item
    item_to_update = @repo.find_by_id(2)
    original_updated_at = item_to_update.updated_at
    @repo.update(2, new_values)

    assert_equal new_values[:name], item_to_update.name
    assert_equal new_values[:description], item_to_update.description
    assert_equal new_values[:unit_price], item_to_update.unit_price
    assert_equal false, (original_updated_at == item_to_update.updated_at)
  end

  def test_can_delete_an_item
    @repo.delete(2)

    assert_equal 1, @repo.all.count
    assert_nil @repo.find_by_id(2)
  end
end
