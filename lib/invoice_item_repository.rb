require_relative 'invoice_item'
require 'csv'
require 'time'
require 'bigdecimal'

class InvoiceItemRepository
  attr_reader :engine

  def initialize(filepath, engine)
    @records = build_records(filepath)
    @engine = engine
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
      invoice_item_from(get_info(row))
    end
  end

  def invoice_item_from(attributes)
    InvoiceItem.new(attributes, self)
  end

  def find_by_id(id)
    all.find do |record|
      record.id == id
    end
  end

  def find_all_by_item_id(item_id)
    all.select do |record|
      record.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    all.select do |record|
      record.invoice_id == invoice_id
    end
  end

  def create(attributes)
    attributes[:id] = max_invoice_item_id + 1
    @records << invoice_item_from(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  private

  def max_invoice_item_id
    all.max_by(&:id).id
  end

  def get_info(row)
    {
      id: row[:id].to_i,
      item_id: row[:item_id].to_i,
      invoice_id: row[:invoice_id].to_i,
      quantity: row[:quantity].to_i,
      unit_price: convert_unit_price(row[:unit_price]),
      created_at: Time.parse(row[:created_at]),
      updated_at: Time.parse(row[:updated_at])
    }
  end

  def convert_unit_price(unit_price)
    BigDecimal(unit_price.to_f / 100, 6)
  end

  def parameters
    {
      headers: true,
      header_converters: :symbol
    }
  end
end
