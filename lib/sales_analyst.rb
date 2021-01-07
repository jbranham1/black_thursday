class SalesAnalyst

  def initialize(merchant_repo, item_repo)
    @merchants = merchant_repo.merchants
    @items = item_repo.items
  end
end
