require_relative "MerchantRepository"
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
    @file = CSV.open file_name, headers: true, header_converters: :symbol
    repository.new(@file)
  end
end
