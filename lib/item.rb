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
    @unit_price = BigDecimal(info[:unit_price] / 100)
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @merchant_id = info[:merchant_id]
  end

  def update(attributes)
    !attributes[:name].nil? && @name = attributes[:name]
    !attributes[:description].nil? && @description = attributes[:description]

    !attributes[:unit_price].nil? &&
    @unit_price = BigDecimal(attributes[:unit_price])
    @updated_at = Time.now
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
