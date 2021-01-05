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
    CSV.open(file, parameters).map do |row|
      info = {
        id: row[:id].to_i,
        name: row[:name]
      }
      add_merchant(info)
    end
  end

  private

  def parameters
    {
      headers: true,
      header_converters: :symbol
    }
  end

  def add_merchant(info)
    Merchant.new(info)
  end
end
