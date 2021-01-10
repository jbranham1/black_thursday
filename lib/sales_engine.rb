require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'
require_relative 'sales_analyst'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices,
              :transactions

  def initialize(files)
    @merchants = load_file(files[:merchants], MerchantRepository)
    @items = load_file(files[:items], ItemRepository)
    @invoices = load_file(files[:invoices], InvoiceRepository)
    @transactions = load_file(files[:transactions], TransactionRepository)
  end

  def self.from_csv(files)
    new(files)
  end

  def load_file(file_name, repository)
    repository.new(file_name, self)
  end

  def items_by_merchant_id(merchant_id)
    @items.find_all_by_merchant_id(merchant_id)
  end

  def invoices_by_merchant_id(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id)
  end

  def invoice_count_by_status(status)
    @invoices.find_all_by_status(status).count
  end

  def invoices_by_day
    @invoices.group_by_day
  end

  def analyst
    SalesAnalyst.new(self)
  end
end
