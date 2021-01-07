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
    @unit_price = BigDecimal(info[:unit_price]/100)
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @merchant_id = info[:merchant_id]
  end

  def update(attributes)
    @name = attributes[:name] if !attributes[:name].nil?
    @description = attributes[:description] if !attributes[:description].nil?

    @unit_price = BigDecimal(attributes[:unit_price]) if !attributes[:unit_price].nil?
    @updated_at = Time.now
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
