require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'sales_analyst'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices

  def initialize(files)
    @merchants = load_file(files[:merchants], MerchantRepository)
    @items = load_file(files[:items], ItemRepository)
    @invoices = load_file(files[:invoices], InvoiceRepository)
  end

  def self.from_csv(files)
    new(files)
  end

  def load_file(file_name, repository)
    repository.new(file_name, self)
  end

  def analyst
    SalesAnalyst.new(@merchants,
                     @items,
                     @invoices)
  end

  def items_by_merchant_id(merchant_id)
    @items.find_all_by_merchant_id(merchant_id)
  end
end
