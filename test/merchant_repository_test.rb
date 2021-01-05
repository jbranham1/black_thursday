require 'minitest/pride'
require 'minitest/autorun'
require 'csv'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
  def test_it_exists
    parameters = { headers: true, header_converters: :symbol }
    file = CSV.open './data/test_merchant.csv', parameters
    repo = MerchantRepository.new(file)

    assert_instance_of MerchantRepository, repo
  end

  def test_build_merchants
    parameters = { headers: true, header_converters: :symbol }
    file = CSV.open './data/test_merchant.csv', parameters
    repo = MerchantRepository.new(file)
    merchant1 = Merchant.new(id: 12_334_105, name: 'Shopin1901')
    merchant2 = Merchant.new(id: 12_334_112, name: 'Candisart')

    assert_equal [merchant1, merchant2], repo.build_merchants
  end
end
