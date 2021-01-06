require './test/test_helper'
require 'csv'
require 'bigdecimal'
require 'item_repository'

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

    assert_equal 1, @repo.items.count
  end
end
