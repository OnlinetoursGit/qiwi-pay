require 'shared/payment_operation'
require 'shared/api_payment_operation'

RSpec.describe QiwiPay::Api::ReversalOperation do
  describe 'act as PaymentOperation' do
    include_examples 'payment_operation'
  end

  describe 'act as API PaymentOperation' do
    include_examples 'api_payment_operation'
  end
end
