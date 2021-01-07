class SalesAnalyst
  def initialize(merchant_repo, item_repo)
    @merchant_repo = merchant_repo
    @item_repo = item_repo
  end

  def average_items_per_merchant
    merchants = @merchant_repo.all

    total_items = merchants.sum do |merchant|
      @item_repo.find_all_by_merchant_id(merchant.id).length
    end

    (total_items.to_f / merchants.length).round(2)
  end
end
