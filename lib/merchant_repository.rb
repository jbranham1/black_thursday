require_relative 'merchant'
require 'csv'

class MerchantRepository
  # attr_reader :file

  def initialize(filepath)
    @merchants = build_merchants(filepath)
    # @file = file
  end

  def all
    @merchants # ||= build_merchants
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

  def find_all_by_name(name)
    all.select do |record|
      record.name.casecmp?(name)
    end
  end

  def build_merchants(filepath)
    CSV.open(filepath, parameters).map do |row|
      merchant_from(get_info(row))
    end
  end

  def merchant_from(attributes)
    Merchant.new(attributes)
  end

  def create(attributes)
    attributes[:id] = max_merchant_id + 1
    @merchants << merchant_from(attributes)
  end

  def update(id, attributes)
    find_by_id(id).update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  private

  def max_merchant_id
    all.max_by(&:id).id
  end

  def get_info(row)
    {
      id: row[:id].to_i,
      name: row[:name]
    }
  end

  def parameters
    {
      headers: true,
      header_converters: :symbol
    }
  end
end
