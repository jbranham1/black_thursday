require_relative 'customer'
require 'csv'
require 'time'

class CustomerRepository
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
      customer_from(get_info(row))
    end
  end

  def customer_from(attributes)
    Customer.new(attributes, self)
  end

  def find_by_id(id)
    all.find do |record|
      record.id == id
    end
  end

  def find_all_by_first_name(first_name)
    all.select do |customer|
      customer.first_name.match?(/(#{Regexp.escape(first_name)})/i)
    end
  end

  def find_all_by_last_name(last_name)
    all.select do |customer|
      customer.last_name.match?(/(#{Regexp.escape(last_name)})/i)
    end
  end

  def create(attributes)
    attributes[:id] = max_id + 1
    @records << customer_from(attributes)
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
      first_name: row[:first_name],
      last_name: row[:last_name],
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
