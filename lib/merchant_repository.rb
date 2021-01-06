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

  def find_all_by_name(name)
    all.select do |record|
      record.name.casecmp?(name)
    end
  end

  def build_merchants
    CSV.open(file, parameters).map do |row|
      info = {
        id: row[:id].to_i,
        name: row[:name]
      }
      create(info)
    end
  end

  def create(info)
    Merchant.new(info)
  end

  def update(id, attributes)
    find_by_id(id).name = attributes[:name]
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  private

  def parameters
    {
      headers: true,
      header_converters: :symbol
    }
  end
end
