require 'shared/payment_operation'
require 'shared/wpf_payment_operation'

RSpec.describe QiwiPay::Wpf::AuthOperation do
  describe 'act as PaymentOperation' do
    include_examples 'payment_operation'
  end

  describe 'act as WPF PaymentOperation' do
    include_examples 'wpf_payment_operation'
  end
end
