# frozen_string_literal: true

require 'json'
require 'ostruct'

module QiwiPay::Api
  # QiwiPay API response
  class Response < OpenStruct
    include QiwiPay::MessagesForCodes

    def initialize(response_code, response_body)
      super JSON.parse(response_body)
      send(:http_code=, response_code)
    end
  end
end
