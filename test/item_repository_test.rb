require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require 'bigdecimal'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  def setup
    @file = CSV.open './data/test_item.csv', headers: true, header_converters: :symbol
  end

  def test_it_exists
    repo = ItemRepository.new(@file)

    assert_instance_of ItemRepository, repo
  end

  def test_build_items
    repo = ItemRepository.new(@file)
    repo.build_items

    repo.items.all? do |item|
      assert_instance_of ItemRepository, item
    end
  end
end
