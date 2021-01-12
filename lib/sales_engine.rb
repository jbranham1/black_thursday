require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'
require_relative 'sales_analyst'
require 'time'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(files)
    @merchants = load_file(files[:merchants], MerchantRepository)
    @items = load_file(files[:items], ItemRepository)
    @invoices = load_file(files[:invoices], InvoiceRepository)
    @invoice_items = load_file(files[:invoice_items], InvoiceItemRepository)
    @transactions = load_file(files[:transactions], TransactionRepository)
    @customers = load_file(files[:customers], CustomerRepository)
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

  def merchants_with_one_item
    @merchants.all.select(&:has_one_item?)
  end

  def merchants_with_one_item_in_month(month)
    merchants_with_one_item.select do |merchant|
      merchant.created_at.strftime("%B") == month
    end
  end

  def analyst
    SalesAnalyst.new(self)
  end
end
