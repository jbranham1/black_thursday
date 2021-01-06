class Merchant
  attr_reader :id,
              :name

  def initialize(merchant_info)
    @id = merchant_info[:id]
    @name = merchant_info[:name]
  end

  def update(attributes)
    @name = attributes[:name]
  end
end
