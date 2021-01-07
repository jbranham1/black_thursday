class SalesAnalyst
  def initialize(merchant_repo, item_repo)
    @merchant_repo = merchant_repo
    @item_repo = item_repo
  end

  def average_items_per_merchant
    total_items = merchants.sum do |merchant|
      @item_repo.find_all_by_merchant_id(merchant.id).length
    end

    (total_items.to_f / merchants.length).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    items_per_merchant = merchants.map do |merchant|
      @item_repo.find_all_by_merchant_id(merchant.id).length
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

  private

  def merchants
    @merchant_repo.all
  end
end
