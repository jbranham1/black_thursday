require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  def test_it_exists
    file = CSV.open './data/test_item.csv', headers: true, header_converters: :symbol
    repo = ItemRepository.new(file)

    assert_instance_of ItemRepository, repo
  end
end
