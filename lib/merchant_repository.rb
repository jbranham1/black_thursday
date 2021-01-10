require_relative 'merchant'
require 'csv'

class MerchantRepository
  attr_reader :engine

  def initialize(filepath, engine)
    @merchants = build_merchants(filepath)
    @engine = engine
  end

  # :nocov:
  def inspect
    "#<\#{self.class} \#{@merchants.size} rows>"
  end
  # :nocov:

  def all
    @merchants
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
      record.name.match?(/(#{Regexp.escape(name)})/i)
    end
  end

  def build_merchants(filepath)
    CSV.open(filepath, parameters).map do |row|
      merchant_from(get_info(row))
    end
  end

  def merchant_from(attributes)
    Merchant.new(attributes, self)
  end

  def create(attributes)
    attributes[:id] = max_merchant_id + 1
    @merchants << merchant_from(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  def items_by_merchant_id(id)
    @engine.items_by_merchant_id(id)
  end

  def invoices_by_merchant_id(id)
    @engine.invoices_by_merchant_id(id)
  end

  def merchant_ids
    @merchant_ids ||= all.map(&:id).sort
  end

  private

  def max_merchant_id
    @max_merchant_id ||= all.max_by(&:id).id
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
