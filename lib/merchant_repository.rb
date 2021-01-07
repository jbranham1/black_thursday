require_relative 'merchant'
require_relative 'base_repository'
require 'csv'

class MerchantRepository < BaseRepository
  attr_reader :all

  def record_class
    Merchant
  end
  # def initialize(filepath)
  #   @all = build_merchants(filepath)
  # end

  # def all
  #   @all
  # end
  #
  # def find_by_id(id)
  #   all.find do |record|
  #     record.id == id
  #   end
  # end

  # def find_by_name(name)
  #   all.find do |record|
  #     record.name.casecmp?(name)
  #   end
  # end

  def find_all_by_name(name)
    @all.select do |record|
      record.name.match?(/(#{Regexp.escape(name)})/i)
    end
  end

  def build_records(filepath)
    CSV.open(filepath, parameters).map do |row|
      record_from(get_info(row))
    end
  end

  # def merchant_from(attributes)
  #   Merchant.new(attributes)
  # end

  # def create(attributes)
  #   attributes[:id] = max_id + 1
  #   @all << merchant_from(attributes)
  # end

  # def update(id, attributes)
  #   find_by_id(id)&.update(attributes)
  # end

  # def delete(id)
  #   @all.delete(find_by_id(id))
  # end

  private

  # def max_merchant_id
  #   @all.max_by(&:id).id
  # end

  def get_info(row)
    {
      id: row[:id].to_i,
      name: row[:name]
    }
  end

  # def parameters
  #   {
  #     headers: true,
  #     header_converters: :symbol
  #   }
  # end
end
