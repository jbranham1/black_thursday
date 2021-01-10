class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :repository

  def initialize(info, repository)
    @id = info[:id]
    @item_id = info[:item_id]
    @invoice_id = info[:invoice_id]
    @quantity = info[:quantity]
    @unit_price = info[:unit_price]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @repository = repository
  end

  def update(attributes)
    attributes[:quantity] && @quantity = attributes[:quantity]
    attributes[:unit_price] && @unit_price = attributes[:unit_price]
    @updated_at = Time.now
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
