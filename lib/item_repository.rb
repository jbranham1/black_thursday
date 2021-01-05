require_relative 'item'

class ItemRepository
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def items
    @items ||= build_items
  end

  def build_items
    parameters = { headers: true, header_converters: :symbol }
    CSV.open(@file, parameters).map do |row|
      info = {
        id: row[:id].to_i,
        name: row[:name],
        description: row[:description],
        unit_price: BigDecimal(row[:unit_price], 4),
        created_at: Time.parse(row[:created_at]),
        updated_at: Time.parse(row[:updated_at]),
        merchant_id: row[:merchant_id].to_i
      }
      Item.new(info)
    end
  end
end
