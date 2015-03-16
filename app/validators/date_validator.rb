require "date"

class DateValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    begin
      Date.parse(value)
    rescue
      # record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end
