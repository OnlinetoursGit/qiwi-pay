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

require "qiwi-pay/version"
require "qiwi-pay/messages_for_codes"
require "qiwi-pay/payment_operation"
require "qiwi-pay/cheque"
require "qiwi-pay/credentials"
require "qiwi-pay/signature"
require "qiwi-pay/confirmation"

require "qiwi-pay/wpf/payment_operation"
require "qiwi-pay/wpf/sale_operation"
require "qiwi-pay/wpf/auth_operation"

require "qiwi-pay/api/payment_operation"
require "qiwi-pay/api/capture_operation"
require "qiwi-pay/api/refund_operation"
require "qiwi-pay/api/reversal_operation"
require "qiwi-pay/api/status_operation"
require "qiwi-pay/api/response"
