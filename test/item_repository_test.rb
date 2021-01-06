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

  def test_can_find_by_description_substring
    actual_returned_items = @repo.find_all_with_description("write")

    sorted_actual_ids = actual_returned_items.map do |item|
      item.id
    end.sort
    expected_ids = [1, 2]

    assert_equal expected_ids, sorted_actual_ids
  end

  def test_can_find_nothing_when_searching_by_description_substring
    assert_equal [], @repo.find_all_with_description("doo-doo")
  end

  def test_can_find_by_price
    actual_returned_items = @repo.find_all_by_price(BigDecimal(10.99, 4))

    sorted_actual_ids = actual_returned_items.map do |item|
      item.id
    end.sort
    expected_ids = [1]

    assert_equal expected_ids, sorted_actual_ids
  end

  def test_can_find_nothing_when_searching_by_price
    assert_equal [], @repo.find_all_by_price(BigDecimal(0, 4))
  end
end
