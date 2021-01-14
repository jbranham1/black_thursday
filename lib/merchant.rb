class Merchant
  attr_reader :id,
              :name,
              :repository,
              :created_at

  def initialize(merchant_info, repository)
    @id = merchant_info[:id]
    @name = merchant_info[:name]
    @repository = repository
    @created_at = merchant_info[:created_at]
  end

  def update(attributes)
    @name = attributes[:name]
  end

  def items
    @items ||= @repository.items_by_merchant_id(@id)
  end

  def invoices
    @invoices ||= @repository.invoices_by_merchant_id(@id)
  end

  def one_item?
    @one_item ||= items.count == 1
  end

  def pending_invoices
    @pending_invoices ||= invoices.reject(&:paid_in_full?)
  end

  def best_item
    @best_item ||= items.max_by(&:total_revenue)
  end

  def most_sold_item
    max = max_quantity
    @most_sold_item ||= items.select do |item|
      item.quantity == max
    end
  end

  def max_quantity
    @max_quantity ||= items.map(&:quantity).max
  end
end
