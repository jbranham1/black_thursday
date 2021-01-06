require './test/test_helper'
require 'csv'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
  def setup
    file = './data/test_merchant.csv'
    @repo = MerchantRepository.new(file)
  end

  def sorted_actual_ids(merchants)
    merchants.map(&:id).sort
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
    assert_equal true, all_merchants.all? do |merchant|
      merchant.is_a?(Merchant)
    end
  end

  def test_can_find_by_id
    merchant = @repo.find_by_id(12_334_105)

    assert_equal 12_334_105, merchant.id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_by_name
    merchant = @repo.find_by_name('Shopin1901')

    assert_equal 'Shopin1901', merchant.name
    assert_nil @repo.find_by_name('Potato')
  end

  def test_can_find_all_by_name
    expected_ids = [12_334_105]
    actual = @repo.find_all_by_name('Shopin1901')

    assert_equal expected_ids, sorted_actual_ids(actual)
  end

  def test_can_find_nothing_when_searching_by_name
    assert_equal [], @repo.find_all_by_name('doo-doo')
  end

  def test_create_merchant
    attributes = { name: 'Turing School' }
    @repo.create(attributes)

    assert_instance_of Merchant, @repo.all.last
    assert_equal 3, @repo.all.count
    assert_equal 12_334_113, @repo.all.last.id
  end

  def test_can_update_merchant
    merchant = @repo.find_by_id(12_334_105)
    attributes = { name: 'Turing School Updated' }
    @repo.update(12_334_105, attributes)

    assert_equal 'Turing School Updated', merchant.name
  end

  def test_can_delete_merchant
    @repo.delete(12_334_105)

    assert_equal 1, @repo.all.count
    assert_nil @repo.find_by_id(12_334_105)
  end
end
