require './test/test_helper'
require 'csv'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
  def setup
    file = './data/test_merchant.csv'
    @repo = MerchantRepository.new(file)
  end

  def test_it_exists
    assert_instance_of MerchantRepository, @repo
  end

  def test_build_merchants
    @repo.build_merchants
    assert_equal 2, @repo.merchants.count
  end
end
