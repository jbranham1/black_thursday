require_relative 'mathable'

class SalesAnalyst
  include Mathable

  def initialize(engine)
    @engine = engine
    @merchant_repo = engine.merchants
    @item_repo = engine.items
    @invoice_repo = engine.invoices
    @invoice_item_repo = engine.invoice_items
    @transaction_repo = engine.transactions
  end

  def average_items_per_merchant
    average(@engine.total_items_for_merchants)
  end

  def average_items_per_merchant_standard_deviation
    items_per_merchant = @engine.items_by_merchant.values.map(&:length)
    standard_deviation(items_per_merchant, average_items_per_merchant)
  end

  def merchants_with_high_item_count
    std_dev = average_items_per_merchant_standard_deviation
    high_item_count = average_items_per_merchant + std_dev

    @engine.items_by_merchant.map do |merchant, items|
      merchant if items.length.to_f > high_item_count
    end.compact
  end

  def average_item_price_for_merchant(merchant_id)
    item_prices = @engine.items_by_merchant_id(merchant_id).map(&:unit_price)
    BigDecimal(average(item_prices), 6)
  end

  def average_average_price_per_merchant
    average_prices = merchant_ids.map do |id|
      average_item_price_for_merchant(id)
    end
    BigDecimal(average(average_prices), 6)
  end

  def golden_items
    # Find the average item price
    item_prices = items.map(&:unit_price)
    average_item_price = average(item_prices)

    # Find standard deviation in item prices
    item_price_std_dev = standard_deviation(item_prices, average_item_price)

    # Cycle thru items, pulling out the ones 2 std dev's above the average
    items.select do |item|
      item.unit_price >= average_item_price + (item_price_std_dev * 2)
    end
  end

  def average_invoices_per_merchant
    total_invoices = @engine.invoices_by_merchant.values.map(&:length)
    average(total_invoices)
  end

  def average_invoices_per_merchant_standard_deviation
    invoices_per_merchant = @engine.invoices_by_merchant.values.map(&:length)

    standard_deviation(invoices_per_merchant, average_invoices_per_merchant)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    high_invoice_count = average_invoices_per_merchant + (std_dev * 2)

    @engine.invoices_by_merchant.map do |merchant, invoice|
      merchant if invoice.length.to_f > high_invoice_count
    end.compact
  end

  def bottom_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    low_invoice_count = average_invoices_per_merchant - (std_dev * 2)

    @engine.invoices_by_merchant.map do |merchant, invoices|
      merchant if invoices.length.to_f < low_invoice_count
    end.compact
  end

  def average_invoices_per_day
    total_per_day = @engine.invoices_by_day.values.map(&:length)
    average(total_per_day)
  end

  def average_invoices_per_day_standard_deviation
    invoices_per_day = @engine.invoices_by_day.values.map(&:length)

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
    percentage(invoice_count, invoices.count)
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
    invoices = @engine.invoices_by_merchant
    invoices.each_with_object({}) do |merchant_invoices, hash|
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

  def merchant_ids
    @merchant_repo.merchant_ids
  end
end
