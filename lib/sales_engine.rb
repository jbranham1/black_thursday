class SalesEngine
  attr_reader :merchants,
              :items

  def initialize(files)
    @merchants = files[:merchants]
    @items = files[:items]
  end

  def self.from_csv(data)
    new(data)
  end
end
