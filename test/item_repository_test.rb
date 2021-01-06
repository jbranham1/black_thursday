require './test/test_helper'
require 'csv'
require 'bigdecimal'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  def setup
    file = './data/test_item.csv'
    @repo = ItemRepository.new(file)
    @repo.build_items
  end

  def sorted_actual_ids(items)
    items.map do |item|
      item.id
    end.sort
  end

  def test_it_exists
    assert_instance_of ItemRepository, @repo
  end

  def test_build_items
    assert_equal 2, @repo.all.count
  end

  def test_can_return_all_items
    all_items = @repo.all

    assert_instance_of Array, all_items
    assert_equal true, all_items.all? { |item| item.is_a? Item }
  end

  def test_can_find_by_id
    pencil = @repo.find_by_id(1)

    assert_equal 1 , pencil.id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_by_name
    pencil = @repo.find_by_name('Pencil')

    assert_equal 'Pencil', pencil.name
    assert_nil @repo.find_by_name('Potato')
  end

  def test_can_find_all_with_description_substring
    expected_ids = [1, 2]

    assert_equal expected_ids, sorted_actual_ids(@repo.find_all_with_description("write"))
  end

  def test_can_find_nothing_when_searching_with_description_substring
    assert_equal [], @repo.find_all_with_description("doo-doo")
  end

  def test_can_find_all_by_price
    expected_ids = [1]

    assert_equal expected_ids, sorted_actual_ids(@repo.find_all_by_price(BigDecimal(10.99, 4)))
  end

  def test_can_find_nothing_when_searching_all_by_price
    assert_equal [], @repo.find_all_by_price(BigDecimal(0, 4))
  end

  def test_can_find_all_by_price_range
    range = (9.99..29.99)
    expected_ids = [1, 2]

    assert_equal expected_ids, sorted_actual_ids(@repo.find_all_by_price_in_range(range))
  end

  def test_can_find_nothing_when_searching_all_by_price_range
    assert_equal [], @repo.find_all_by_price_in_range((1.99..9.99))
  end

  def test_can_find_all_by_merchant_id
    expected_ids = [1, 2]

    assert_equal expected_ids, sorted_actual_ids(@repo.find_all_by_merchant_id(2))
  end

  def test_can_find_nothing_when_searching_all_by_merchant_id
    assert_equal [], @repo.find_all_by_merchant_id(0)
  end

  def test_create_item
    attributes = {
      id: 1,
      name: 'Pencil',
      description: 'You can use it to write things.',
      unit_price: BigDecimal(10.99, 4),
      created_at: Time.now,
      updated_at: Time.now,
      merchant_id: 2
    }

    assert_instance_of Item, @repo.create(attributes)
  end
end
