require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'sales_analyst'

class SalesEngine
  attr_reader :merchant_repository,
              :item_repository,
              :invoice_repository

  def initialize(files)
    @merchant_repository = load_file(files[:merchants], MerchantRepository)
    @item_repository = load_file(files[:items], ItemRepository)
    @invoice_repository = load_file(files[:invoices], InvoiceRepository)
  end

  def self.from_csv(files)
    new(files)
  end

  def load_file(file_name, repository)
    repository.new(file_name, self)
  end

  def analyst
    SalesAnalyst.new(@merchant_repository,
                     @item_repository,
                     @invoice_repository)
  end

  def items_by_merchant_id(merchant_id)
    @item_repository.find_all_by_merchant_id(merchant_id)
  end
end
