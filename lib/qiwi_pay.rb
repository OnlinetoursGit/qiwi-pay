# frozen_string_literal: true
require "qiwi_pay/version"
require "qiwi_pay/wpf/signature"
require "qiwi_pay/wpf/confirmation"
require "qiwi_pay/wpf/payment_operation"
require "qiwi_pay/wpf/sale_operation"
require "qiwi_pay/wpf/cheque"

module QiwiPay
  # Web Payment Form interface interaction implementation
  # @see https://developer.qiwi.com/ru/qiwipay/index.html?php#qiwipay-wpf
  module Wpf
    # QiwiPay WPF host
    ENDPOINT_HOST = 'pay.qiwi.com'

    # QiwiPay WPF endpoint
    ENDPOINT_PATH = '/paypage/initial'
  end

  # JSON API interaction implementation
  # @see https://developer.qiwi.com/ru/qiwipay/index.html?json#section-6
  module Api
  end
end
