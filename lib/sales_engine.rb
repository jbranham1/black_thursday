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

  def merchants_with_one_item
    @merchants.all.select(&:one_item?)
  end

  def merchants_with_one_item_in_month(month)
    merchants_with_one_item.select do |merchant|
      merchant.created_at.strftime('%B') == month
    end
  end

  def invoices_by_day
    @invoices.group_by_day
  end

  def most_sold_item_for_merchant(merchant_id)
    @merchants.most_sold_item_for_merchant(merchant_id)
  end

  def invoice_items_by_item(item_id)
    @invoice_items.find_all_by_item_id(item_id)
  end

  def analyst
    SalesAnalyst.new(self)
  end

  def transactions_with_result(result)
    @transactions.find_all_by_result(result)
  end

  def invoice_info_for(invoice_ids)
    @invoice_items.find_all_by_invoice_ids(invoice_ids)
  end

  def invoices_with_status(status)
    @invoices.find_all_by_status(status)
  end

  def merchants_with_ids(ids)
    @merchants.merchants_with_ids(ids)
  end

  def transactions_for_invoice(invoice_id)
    @transactions.find_all_by_invoice_id(invoice_id)
  end

  def merchants_with_pending_invoices
    @merchants.merchants_with_pending_invoices
  end
end
