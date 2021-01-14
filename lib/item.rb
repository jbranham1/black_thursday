class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id,
              :repository

  def initialize(info, repository)
    @id = info[:id]
    @name = info[:name]
    @description = info[:description]
    @unit_price = info[:unit_price]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @merchant_id = info[:merchant_id]
    @repository = repository
  end

  def update(attributes)
    attributes[:name] && @name = attributes[:name]
    attributes[:description] && @description = attributes[:description]
    attributes[:unit_price] && @unit_price = attributes[:unit_price]
    @updated_at = Time.now
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def invoice_items
    @invoice_items ||= @repository.invoice_items_by_item(@id)
  end

  def total_revenue
    @total_revenue ||= invoice_items.sum(&:revenue)
  end

  def quantity
    @quantity ||= invoice_items.sum(&:quantity)
  end
end
