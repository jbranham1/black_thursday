require './test/test_helper'
require 'csv'
require 'bigdecimal'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  def setup
    file = './data/test_item.csv'
    @repo = ItemRepository.new(file)
  end

  def test_it_exists
    assert_instance_of ItemRepository, @repo
  end

  def test_build_items
    @repo.build_items

    assert_equal 1, @repo.all.count
  end

  def test_can_return_all_items
    @repo.build_items
    all_items = @repo.all

    assert_instance_of Array, all_items
    assert_equal true, all_items.all? { |item| item.is_a? Item }
  end
end
