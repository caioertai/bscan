# app/helpers/application_helper.rb
module ApplicationHelper
  def monetize(money_integer, currency = 'BRL')
    Money.new(money_integer, currency).format
  end
end
