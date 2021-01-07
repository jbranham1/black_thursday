class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id

  def initialize(info)
    @id = info[:id]
    @name = info[:name]
    @description = info[:description]
    require 'pry'; binding.pry
    @unit_price = info[:unit_price]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @merchant_id = info[:merchant_id]
  end

  def update(attributes)
    @name = attributes[:name]
    @description = attributes[:description]
    @unit_price = attributes[:unit_price]
    @updated_at = Time.now
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
