# frozen_string_literal: true

require 'openssl'

module QiwiPay
  # Qiwi payment signature calculator
  class Signature
    # @param params [Hash] request parameters
    # @param secret [String] secret key for signature
    def initialize(params, secret)
      @params = params.dup.tap do |hs|
        hs.delete :sign
        hs.delete 'sign'
        hs.delete :cheque
        hs.delete 'cheque'
        hs.delete :merchant_cheque
        hs.delete 'merchant_cheque'
      end
      @secret = secret.to_s
    end

    # Calculates signature
    # @return [String] params signature
    def sign
      digest = OpenSSL::Digest.new('sha256')
      OpenSSL::HMAC.hexdigest(digest, @secret, build_params_string)
    end

    private

    def build_params_string
      map_sorted(@params) { |_k, v| v }.reject(&:nil?)
                                       .map(&:to_s)
                                       .reject(&:empty?)
                                       .join('|')
    end

    # Maps hash yielding key-value pairs ordered by key
    def map_sorted(hash)
      hash.keys
          .sort_by(&:to_sym)
          .map { |k| yield k, hash[k] }
    end
  end
end
