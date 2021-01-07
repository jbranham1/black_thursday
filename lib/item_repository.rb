require_relative 'item'
require 'csv'
require 'bigdecimal'

class ItemRepository
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def inspect
    "#<\#{self.class} \#{@items.size} rows>"
  end

  def items
    @items ||= build_items
  end

  def build_items
    CSV.open(@file, parameters).map do |row|
      Item.new(get_info(row))
    end
  end

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

  private

  def parameters
    { headers: true, header_converters: :symbol }
  end
end
