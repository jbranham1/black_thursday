require_relative 'item'

class ItemRepository
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def all
    @items ||= build_items
  end

  def find_by_id(id)
    all.find do |item|
      item.id == id
    end
  end

  def find_by_name(name)
    all.find do |item|
      item.name.casecmp?(name)
    end
  end

  def find_all_with_description(description)
    all.select do |item|
      item.description.match?(/#{Regexp.escape(description)}/i)
    end
  end

  def find_all_by_price(price)
    all.select do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    all.select do |item|
      range.include?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    all.select do |item|
      item.merchant_id == merchant_id
    end
  end

  def build_items
    CSV.open(@file, parameters).map do |row|
      Item.new(get_info(row))
    end
  end

  private

  def get_info(row)
    {
      id: row[:id].to_i,
      name: row[:name],
      description: row[:description],
      unit_price: BigDecimal(row[:unit_price], 4),
      created_at: Time.parse(row[:created_at]),
      updated_at: Time.parse(row[:updated_at]),
      merchant_id: row[:merchant_id].to_i
    }
  end

  def parameters
    { headers: true, header_converters: :symbol }
  end
end
