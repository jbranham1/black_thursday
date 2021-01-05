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
    repo.build_merchants

    repo.merchants.all? do |merchant|
      merchant.Class == MerchantRepository
    end
  end
end
