class Merchant
  attr_reader :id,
              :name,
              :repository

  def initialize(merchant_info, repository)
    @id = merchant_info[:id]
    @name = merchant_info[:name]
    @repository = repository
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
end
