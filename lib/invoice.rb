require 'time'

class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :repository

  def initialize(info, repository)
    @id = info[:id]
    @customer_id = info[:customer_id]
    @merchant_id = info[:merchant_id]
    @status = info[:status]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @repository = repository
  end

  def update(attributes)
    attributes[:status] && @status = attributes[:status]
    @updated_at = Time.now
  end
end
