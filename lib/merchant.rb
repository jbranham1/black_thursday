class Merchant
  attr_reader :id,
              :name,
              :repository

  def initialize(merchant_info, repository)
    @id = merchant_info[:id]
    @name = merchant_info[:name]
    @repository = repository
  end

  def update(attributes)
    @name = attributes[:name]
  end
end
