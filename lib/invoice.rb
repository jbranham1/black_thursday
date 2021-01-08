require 'time'

class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at

  def initialize(info)
    @id = info[:id]
    @customer_id = info[:customer_id]
    @merchant_id = info[:merchant_id]
    @status = info[:status]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
  end

  def update(attributes)
    attributes[:status] && @status = attributes[:status]
    @updated_at = convert_to_long_time
  end

  def convert_to_long_time
    d = Time.now
    Time.parse(d.strftime('%F %T.%L%L%L %z'))
  end
end
