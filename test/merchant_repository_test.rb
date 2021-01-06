require './test/test_helper'
require 'csv'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
  def setup
    file = './data/test_merchant.csv'
    @repo = MerchantRepository.new(file)
  end

  def sorted_actual_ids(merchants)
    merchants.map do |merchant|
      merchant.id
    end.sort
  end

  def test_it_exists
    assert_instance_of MerchantRepository, @repo
  end

  def test_build_merchants
    assert_equal 2, @repo.all.count
  end

  def test_can_return_all_items
    all_merchants = @repo.all

    assert_instance_of Array, all_merchants
    assert_equal true, all_merchants.all? { |merchant| merchant.is_a? Merchant }
  end

  def test_can_find_by_id
    merchant = @repo.find_by_id(12334105)

    assert_equal 12334105, merchant.id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_by_name
    merchant = @repo.find_by_name('Shopin1901')

    assert_equal 'Shopin1901', merchant.name
    assert_nil @repo.find_by_name('Potato')
  end

  def test_can_find_all_by_name
    expected_ids = [12334105]

    assert_equal expected_ids, sorted_actual_ids(@repo.find_all_by_name("Shopin1901"))
  end

  def test_can_find_nothing_when_searching_by_name
    assert_equal [], @repo.find_all_by_name("doo-doo")
  end

  def test_create_merchant
    attributes = { id: 5, name: 'Turing School' }

    assert_instance_of Merchant, @repo.create(attributes)
  end

  def test_can_update_merchant
    merchant =  @repo.find_by_id(12334105)
    attributes = { name: 'Turing School Updated' }
    @repo.update(12334105, attributes)

    assert_equal 'Turing School Updated', merchant.name
  end

  def test_can_delete_merchant
    merchant =  @repo.find_by_id(12334105)
    @repo.delete(12334105)

    assert_equal 1, @repo.all.count
    assert_nil @repo.find_by_id(12334105)
  end
end
