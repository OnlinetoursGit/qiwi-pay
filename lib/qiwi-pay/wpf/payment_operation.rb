# frozen_string_literal: true

require 'cgi'

module QiwiPay::Wpf
  # WPF payment operation
  #
  # Generates URL or form parameters which should be used to perform
  # operation
  class PaymentOperation < QiwiPay::PaymentOperation
    # @return [String] payment form redirection URL
    # @example
    #   https://pay.qiwi.com/paypage/initial?opcode=1&merchant_site=111111
    #   &currency=643&amount=1000.00&order_id=1234&email=client@example.com
    #   &country=RUS&city=Moscow&product_name=%D0%9E%D0%BF%D0%BB%D0%B0%D1
    #   %82%D0%B0+%D1%82%D1%83%D1%80%D0%B0&merchant_uid=432101
    #   &callback_url=https%3A%2F%example.com%2Fpayment%2Fcallback
    #   &sign=...c4dbf...
    def url
      qry = request_params.map do |k, v|
        "#{k}=#{CGI.escape(v)}" unless v.nil? || v.empty?
      end.compact.join('&')
      URI::HTTPS.build(
        host: QiwiPay::Wpf::ENDPOINT_HOST,
        path: QiwiPay::Wpf::ENDPOINT_PATH,
        query: qry
      ).to_s
    end

    # @return [Hash] params for payment form
    # @example
    #   {
    #     :method=>:get,
    #     :url=>"https://pay.qiwi.com/paypage/initial",
    #     :opcode=>"1",
    #     :merchant_site=>"111111",
    #     :currency=>"643",
    #     :amount=>"1000.00",
    #     :order_id=>"1234",
    #     :email=>"me@example.com",
    #     :country=>"RUS",
    #     :city=>"Moscow",
    #     :product_name=>"Оплата тура",
    #     :merchant_uid=>"432101",
    #     :callback_url=>"https://example.com/payment/callback",
    #     :sign=>"...c4dbf..."
    #   }
    def params
      {
        method: :get,
        url: URI::HTTPS.build(
          host: QiwiPay::Wpf::ENDPOINT_HOST,
          path: QiwiPay::Wpf::ENDPOINT_PATH
        ).to_s
      }.merge(request_params)
    end

    def params_valid?
      !opcode.nil? &&
        !merchant_site.nil? &&
        !currency.nil?
    end
  end
end
