class SalesAnalyst
  def initialize(engine)
    @engine = engine
    @merchant_repo = engine.merchants
    @item_repo = engine.items
    @invoice_repo = engine.invoices
  end

  def average_items_per_merchant
    total_items = items_by_merchant.values.sum(&:length)
    (total_items.to_f / merchants.length).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    items_per_merchant = items_by_merchant.values.map(&:length)

    standard_deviation(items_per_merchant, mean)
  end

  def merchants_with_high_item_count
    mean = average_items_per_merchant
    std_dev = average_items_per_merchant_standard_deviation
    high_item_count = mean + std_dev

    items_by_merchant.map do |merchant, items|
      merchant if items.length.to_f > high_item_count
    end.compact
  end

  def items_by_merchant
    merchants.each_with_object({}) do |merchant, hash|
      hash[merchant] = @engine.items_by_merchant_id(merchant.id)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    items_for(merchant_with_id(merchant_id)).sum(&:unit_price)
  end

  def golden_items
    # TODO: implement
  end

  def average_invoices_per_merchant
    (invoices_by_merchant.values.sum(&:count)/ merchants.count.to_f).round(2)
  end

  def invoices_by_merchant
    merchants.each_with_object({}) do |merchant, hash|
      hash[merchant] = @engine.invoices_by_merchant_id(merchant.id)
    end
  end

  def average_invoices_per_merchant_standard_deviation
    invoices_per_merchant = invoices_by_merchant.values.map(&:length)

    standard_deviation(invoices_per_merchant, average_invoices_per_merchant)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    high_invoice_count = average_invoices_per_merchant + (std_dev * 2)

    invoices_by_merchant.map do |merchant, invoice|
      merchant if invoice.length.to_f > high_invoice_count
    end.compact
  end

  def bottom_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    low_invoice_count = average_invoices_per_merchant - (std_dev * 2)

    invoices_by_merchant.map do |merchant, invoice|
      merchant if invoice.length.to_f < low_invoice_count
    end.compact
  end

  def top_days_by_invoice_count
    # TODO: implement
  end

  def invoice_status(status)
    invoice_count = @engine.invoice_count_by_status(status)
    ((invoice_count.to_f / invoices.count) * 100).round(2)
  end

  private

  def merchants
    @merchant_repo.all
  end

  def invoices
    @invoice_repo.all
  end

  def merchant_with_id(id)
    @merchant_repo.find_by_id(id)
  end

  def items_for(merchant)
    items_by_merchant[merchant]
  end

  # === MATH METHODS ===
  def standard_deviation(set, mean)
    # Take the difference between each number and the mean and square it
    step1 = set.map do |num|
      (num - mean)**2
    end

    # Sum these square differences together
    step2 = step1.reduce(:+)

    # Divide the sum by the number of elements minus 1
    step3 = step2 / (step1.length - 1)

    # Take the square root of this result
    Math.sqrt(step3).round(2)
  end
end
