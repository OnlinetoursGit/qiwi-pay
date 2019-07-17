# frozen_string_literal: true

require 'rest_client'

module QiwiPay::Api
  # General QiwiPay API payment operation request
  class PaymentOperation < QiwiPay::PaymentOperation
    # @return [Response]
    def perform
      res = RestClient::Resource.new(
        url,
        ssl_client_cert: credentials.certificate,
        ssl_client_key:  credentials.key,
        verify_ssl:      OpenSSL::SSL::VERIFY_PEER
      ).post(request_params.to_json)

      Response.new res.code, res.body
    rescue RestClient::Unauthorized, RestClient::Forbidden
      Response.new 403, 'Access denied'
    rescue RestClient::ExceptionWithResponse => e
      Response.new e.response.code, e.response.body
    end

    private

    def url
      URI::HTTPS.build(
        host: ENDPOINT_HOST,
        path: ENDPOINT_PATH
      ).to_s
    end
  end
end
