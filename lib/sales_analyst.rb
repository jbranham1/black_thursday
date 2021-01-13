class SalesAnalyst
  def initialize(engine)
    @engine = engine
    @merchant_repo = engine.merchants
    @item_repo = engine.items
    @invoice_repo = engine.invoices
    @invoice_item_repo = engine.invoice_items
    @transaction_repo = engine.transactions
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

  def average_item_price_for_merchant(merchant_id)
    # TODO: Memoize a method `average_item_price` on Merchant?
    # And make this method fwd that msg to MerchantRepo which fwds to Merchant?
    item_prices = items_for(merchant_with_id(merchant_id)).map(&:unit_price)
    average(item_prices, 2)
  end

  def average_average_price_per_merchant
    # TODO: MUST optimize this, it's very slow.
    average_prices = merchant_ids.map do |id|
      average_item_price_for_merchant(id)
    end

    average(average_prices, 2)
  end

  def items_by_merchant
    merchants.each_with_object({}) do |merchant, hash|
      hash[merchant] = @engine.items_by_merchant_id(merchant.id)
    end
  end

  def golden_items
    # Find the average item price
    item_prices = items.map(&:unit_price)
    average_item_price = average(item_prices, 2)

    # Find standard deviation in item prices
    item_price_std_dev = standard_deviation(item_prices, average_item_price)

    # Cycle thru items, pulling out the ones 2 std dev's above the average
    items.select do |item|
      item.unit_price >= average_item_price + (item_price_std_dev * 2)
    end
  end

  def average_invoices_per_merchant
    (invoices_by_merchant.values.sum(&:count) / merchants.count.to_f).round(2)
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

    invoices_by_merchant.map do |merchant, invoices|
      merchant if invoices.length.to_f < low_invoice_count
    end.compact
  end

  def average_invoices_per_day
    (@engine.invoices_by_day.values.sum(&:count) / 7).round(2)
  end

  def average_invoices_per_day_standard_deviation
    invoices_per_day = @engine.invoices_by_day.values.map(&:count)

    standard_deviation(invoices_per_day, average_invoices_per_day)
  end

  def top_days_by_invoice_count
    std_dev = average_invoices_per_day_standard_deviation
    count = average_invoices_per_day + std_dev

    @engine.invoices_by_day.map do |day, invoices|
      day if invoices.length.to_f > count
    end.compact
  end

  def invoice_status(status)
    invoice_count = @engine.invoice_count_by_status(status)
    ((invoice_count.to_f / invoices.count) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    @transaction_repo.paid_in_full?(invoice_id)
  end

  def invoice_total(invoice_id)
    calculate_invoice_total(invoice_id) if invoice_paid_in_full?(invoice_id)
  end

  def total_revenue_by_date(date)
    @engine.invoices_on(date).sum do |invoice|
      invoice_total(invoice.id)
    end
  end

  def top_revenue_earners(num_of_merchants = 20)
    merchants_sorted_by_revenue.keys.first(num_of_merchants)
  end

  def merchants_with_revenue
    invoices_by_merchant.each_with_object({}) do |merchant_invoices, hash|
      merchant = merchant_invoices[0]
      hash[merchant] = BigDecimal(revenue_by_merchant(merchant.id), 6)
    end
  end

  def merchants_sorted_by_revenue
    merchants_with_revenue.sort_by do |_, revenue|
      -revenue
    end.to_h
  end

  def merchants_with_only_one_item
    @engine.merchants_with_one_item
  end

  def merchants_with_only_one_item_registered_in_month(month)
    @engine.merchants_with_one_item_in_month(month)
  end

  def revenue_by_merchant(merchant_id)
    merchant_invoices = @engine.invoices_by_merchant_id(merchant_id)
    successful_transactions = @engine.transactions_with_result(:success)
    invoice_ids = overlapping_invoice_ids(merchant_invoices, successful_transactions)
    invoice_info = @engine.invoice_info_for(invoice_ids)

    invoice_info.sum do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end
  end

  def merchants_with_pending_invoices
    @engine.merchants_with_pending_invoices
  end

  def most_sold_item_for_merchant(merchant_id)
    @engine.most_sold_item_for_merchant(merchant_id)
  end

  def best_item_for_merchant(merchant_id)
    @engine.best_item_for_merchant(merchant_id)
  end

  private

  def items
    @item_repo.all
  end

  def items_for(merchant)
    items_by_merchant[merchant]
  end

  def invoices
    @invoice_repo.all
  end

  def calculate_invoice_total(invoice_id)
    @invoice_item_repo.invoice_total(invoice_id)
  end

  def overlapping_invoice_ids(merchant_invoices, successful_transactions)
    merchant_invoice_ids = merchant_invoices.map(&:id)
    transaction_invoice_ids = successful_transactions.map(&:invoice_id)

    merchant_invoice_ids & transaction_invoice_ids
  end

  def merchants
    @merchant_repo.all
  end

  def merchant_ids
    @merchant_repo.merchant_ids
  end

  def merchant_with_id(id)
    @merchant_repo.find_by_id(id)
  end

  def merchant_ids_from(pending_invoices)
    pending_invoices.map(&:merchant_id).uniq
  end

  # === MATH METHODS ===
  def standard_deviation(set, mean)
    # Take the difference between each number and the mean and square it
    step1 = set.map do |num|
      (num - mean)**2
    end

    # Sum these square differences together
    step2 = sum(step1)

    # Divide the sum by the number of elements minus 1
    step3 = step2 / (step1.length - 1)

    # Take the square root of this result
    Math.sqrt(step3).round(2)
  end

  def average(set, round_precision)
    (sum(set) / set.length).round(round_precision)
  end

  def sum(set)
    set.reduce(:+)
  end
end
