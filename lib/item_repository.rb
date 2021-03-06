require_relative 'item'
require 'csv'
require 'bigdecimal'
require 'time'

class ItemRepository
  attr_reader :engine

  def initialize(filepath, engine)
    @items = build_items(filepath)
    @engine = engine
  end

  # :nocov:
  def inspect
    "#<\#{self.class} \#{@items.size} rows>"
  end
  # :nocov:

  def all
    @items
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
      range.include?(item.unit_price_to_dollars)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    all.select do |item|
      item.merchant_id == merchant_id
    end
  end

  def build_items(filepath)
    CSV.open(filepath, parameters).map do |row|
      item_from(get_info(row))
    end
  end

  def item_from(attributes)
    Item.new(attributes, self)
  end

  def create(attributes)
    attributes[:id] = max_item_id + 1

    @items << item_from(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  def invoice_items_by_item(item_id)
    @engine.invoice_items_by_item(item_id)
  end

  private

  def max_item_id
    all.max_by(&:id).id
  end

  def get_info(row)
    {
      id: row[:id].to_i,
      name: row[:name],
      description: row[:description],
      unit_price: BigDecimal(row[:unit_price].to_f / 100, 6),
      created_at: Time.parse(row[:created_at]),
      updated_at: Time.parse(row[:updated_at]),
      merchant_id: row[:merchant_id].to_i
    }
  end

  def parameters
    { headers: true, header_converters: :symbol }
  end
end
