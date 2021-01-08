require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'sales_analyst'

class SalesEngine
  attr_reader :merchants,
              :items

  def initialize(files)
    @merchants = load_file(files[:merchants], MerchantRepository)
    @items = load_file(files[:items], ItemRepository)
  end

  def self.from_csv(files)
    new(files)
  end

  def load_file(file_name, repository)
    repository.new(file_name)
  end

  def analyst
    SalesAnalyst.new(@merchants, @items)
  end
end
