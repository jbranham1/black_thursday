require './lib/merchant_repository'
require './lib/item_repository'

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
end
