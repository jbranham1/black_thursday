require_relative 'transaction'
require 'csv'
require 'time'

class TransactionRepository
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
      transaction_from(get_info(row))
    end
  end

  def transaction_from(attributes)
    Transaction.new(attributes, self)
  end

  def find_by_id(id)
    all.find do |record|
      record.id == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    all.select do |record|
      record.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.select do |record|
      record.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    all.select do |record|
      record.result == result
    end
  end

  def create(attributes)
    attributes[:id] = max_id + 1
    @records << transaction_from(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  private

  def max_id
    all.max_by(&:id).id
  end

  def get_info(row)
    {
      id: row[:id].to_i,
      invoice_id: row[:invoice_id].to_i,
      credit_card_number: row[:credit_card_number],
      credit_card_expiration_date: row[:credit_card_expiration_date],
      result: row[:result].to_sym,
      created_at: Time.parse(row[:created_at]),
      updated_at: Time.parse(row[:updated_at])
    }
  end

  def parameters
    {
      headers: true,
      header_converters: :symbol
    }
  end
end
