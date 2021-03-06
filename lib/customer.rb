require 'time'

class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :repository

  def initialize(info, repository)
    @id = info[:id]
    @first_name = info[:first_name]
    @last_name = info[:last_name]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @repository = repository
  end

  def update(attributes)
    attributes[:first_name] && @first_name = attributes[:first_name]
    attributes[:last_name] && @last_name = attributes[:last_name]
    @updated_at = Time.now
  end
end
