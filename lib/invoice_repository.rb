require_relative 'invoice'
require 'csv'

class InvoiceRepository
  def initialize(filepath)
    @records = build_records(filepath)
  end

  # :nocov:
  def inspect
    "#<\#{self.class} \#{@records.size} rows>"
  end
  # :nocov:

  def all
    @records
  end

  def build_records(filepath)
    CSV.open(filepath, parameters).map do |row|
      invoice_from(get_info(row))
    end
  end

  def invoice_from(attributes)
    Invoice.new(attributes)
  end

  def find_by_id(id)
    all.find do |record|
      record.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    all.select do |record|
      record.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    all.select do |record|
      record.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    all.select do |record|
      record.status.casecmp?(status)
    end
  end

  def create(attributes)
    attributes[:id] = max_invoice_id + 1
    @records << invoice_from(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end
  
  def delete(id)
    all.delete(find_by_id(id))
  end

  private

  def max_invoice_id
    all.max_by(&:id).id
  end

  def get_info(row)
    {
      id: row[:id].to_i,
      customer_id: row[:customer_id].to_i,
      merchant_id: row[:merchant_id].to_i,
      status: row[:status],
      created_at: row[:created_at],
      updated_at: row[:updated_at]
    }
  end

  def parameters
    {
      headers: true,
      header_converters: :symbol
    }
  end
end
