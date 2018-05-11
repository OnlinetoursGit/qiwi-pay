# frozen_string_literal: true

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
    # QiwiPay API host
    ENDPOINT_HOST = 'acquiring.qiwi.com'

    # QiwiPay API endpoint
    ENDPOINT_PATH = '/merchant/direct'
  end
end

require "qiwi_pay/version"
require "qiwi_pay/messages_for_codes"
require "qiwi_pay/payment_operation"
require "qiwi_pay/cheque"
require "qiwi_pay/credentials"
require "qiwi_pay/signature"
require "qiwi_pay/confirmation"

require "qiwi_pay/wpf/payment_operation"
require "qiwi_pay/wpf/sale_operation"
require "qiwi_pay/wpf/auth_operation"

require "qiwi_pay/api/payment_operation"
require "qiwi_pay/api/response"
