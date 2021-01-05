class SalesEngine
  attr_reader :merchants,
              :items

  def initialize(files)
    @merchants = MerchantRepository.new(files[:merchants])
    @items = ItemRepository.new(files[:merchants])
  end

  def self.from_csv(data)
    new(data)
  end
end
