require 'time'

class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :repository

  def initialize(info, repository)
    @id = info[:id]
    @invoice_id = info[:invoice_id]
    @credit_card_number = info[:credit_card_number]
    @credit_card_expiration_date = info[:credit_card_expiration_date]
    @result = info[:result]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
    @repository = repository
  end

  def update(attributes)
    attributes[:credit_card_number] &&
      @credit_card_number = attributes[:credit_card_number]
    attributes[:credit_card_expiration_date] &&
      @credit_card_expiration_date = attributes[:credit_card_expiration_date]
    attributes[:result] && @result = attributes[:result]
    @updated_at = Time.now
  end
end
