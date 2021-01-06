require_relative 'merchant'

class MerchantRepository
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def all
    @merchants ||= build_merchants
  end

  def find_by_id(id)
    all.find do |record|
      record.id == id
    end
  end

  def find_by_name(name)
    all.find do |record|
      record.name.casecmp?(name)
    end
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
