class SalesAnalyst
  def initialize(merchant_repo, item_repo)
    @merchant_repo = merchant_repo
    @item_repo = item_repo
  end

  def average_items_per_merchant
    total_items = items_by_merchant.values.sum do |items|
      items.length
    end

    (total_items.to_f / merchants.length).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    items_per_merchant = items_by_merchant.values.map do |items|
      items.length
    end

    # Take the difference between each number and the mean and square it
    step1 = items_per_merchant.map do |num|
      (num - mean)**2
    end

    # Sum these square differences together
    step2 = step1.reduce(:+)

    # Divide the sum by the number of elements minus 1
    step3 = step2 / (step1.length - 1)

    # Take the square root of this result
    Math.sqrt(step3).round(2)
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
    merchants.each_with_object({}) do |merchant, items_by_merchant|
      items_by_merchant[merchant] = @item_repo.find_all_by_merchant_id(merchant.id)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    items_for(merchant_with_id(merchant_id)).sum(&:unit_price)
  end

  private

  def merchants
    @merchant_repo.all
  end

  def merchant_with_id(id)
    @merchant_repo.find_by_id(id)
  end

  def items_for(merchant)
    items_by_merchant[merchant]
  end
end
