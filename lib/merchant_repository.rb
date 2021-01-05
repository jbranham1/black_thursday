require_relative 'merchant'

class MerchantRepository
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def merchants
    @merchants ||= build_merchants
  end

  def build_merchants
    parameters = { headers: true, header_converters: :symbol }
    CSV.open(file, parameters).map do |row|
      info = {
        id: row[:id].to_i,
        name: row[:name]
      }
      Merchant.new(info)
    end
  end
end
