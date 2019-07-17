# frozen_string_literal: true

require 'json'
require 'ostruct'

module QiwiPay::Api
  # QiwiPay API response
  class Response < OpenStruct
    include QiwiPay::MessagesForCodes

    # Parameters of integer type
    INTEGER_PARAMS = %w[
      txn_id
      txn_status
      txn_type
      error_code
      currency
    ]

    # @param response_code [Integer] HTTP response status code
    # @param response_body [String] Response body in JSON
    def initialize(response_code, response_body)
      begin
        params = JSON.parse(response_body)
        (INTEGER_PARAMS & params.keys).each do |p|
          params[p] = params[p] && params[p].to_i
        end
        super params
      rescue JSON::ParserError
        super error_code: -1
        define_singleton_method :error_message, ->{ response_body }
      end
      send(:http_code=, response_code)
    end

    def success?
      http_code == 200 && error_code == 0
    end
  end
end
