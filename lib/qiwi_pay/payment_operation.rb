# frozen_string_literal: true

require 'cgi'

module QiwiPay
  # General patment operation
  class PaymentOperation
    # Код операции
    def self.opcode
      raise NotImplementedError
    end

    # Описание операции
    def self.description
      raise NotImplementedError
    end

    ATTRIBUTES = %i[
      txn_id
      merchant_site currency sign amount order_id
      email country city region address phone
      cf1 cf2 cf3 cf4 cf5
      product_name merchant_uid modifiers card_token order_expire
      callback_url success_url decline_url
      cheque
    ].freeze

    attr_accessor(*ATTRIBUTES)
    attr_writer :credentials

    def initialize(credentials, params = {})
      params.each do |k, v|
        send("#{k}=", v) if ATTRIBUTES.include?(k.to_sym)
      end
      @credentials = credentials
    end

    def opcode
      self.class.opcode
    end

    def description
      self.class.description
    end

    # Formatted amount
    # @return [String]
    def amount
      return unless @amount
      format '%.2f', @amount
    end

    def callback_url=(url)
      raise ArgumentError, 'Use https URI as callback_url' unless url.start_with?('https://')
      @callback_url = url
    end

    private

    attr_reader :credentials

    # Builds hash with meaningful params only
    # @return [Hash]
    def params_hash
      %i[opcode].push(*ATTRIBUTES)
                .map { |a| [a, send(a).to_s] }
                .to_h
                .reject { |_k, v| v.nil? || v.empty? }
    end

    # Builds and signs request parameters
    # @return [Hash]
    def request_params
      params_hash.tap do |params|
        params[:sign] = Signature.new(params, credentials.secret).sign
      end
    end

    def cheque
      return @cheque.encode if @cheque.is_a? Cheque
      @cheque
    end
  end
end
