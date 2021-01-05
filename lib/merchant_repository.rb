require_relative "merchant"
require 'pry'

class MerchantRepository
  attr_reader :csv

  def initialize(csv)
    @csv = csv
  end

  def merchants
    @merchants ||= build_merchants
  end

  def build_merchants
    @csv.map do |row|
      info = {
        id: row[:id].to_i,
        name: row[:name]
      }
      Merchant.new(info)
    end
  end
end
