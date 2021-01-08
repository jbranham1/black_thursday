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
    d = DateTime.now
    t = Time.now
    dt = DateTime.new(d.year, d.month, d.day, d.hour, d.min, d.sec, t.zone)
    Time.parse(dt.strftime("%F %T.%L%L%L %z"))
  end
end
