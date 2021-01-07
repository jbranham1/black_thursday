require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'

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
    repository.new(file_name)
  end
end
