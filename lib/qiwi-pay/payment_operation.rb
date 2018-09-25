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
      cheque merchant_cheque
    ].freeze

    attr_accessor(*ATTRIBUTES)
    attr_writer :credentials

    def initialize(credentials, params = {})
      params.each do |k, v|
        send("#{k}=", v) if in_params.include?(k.to_sym)
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

    # @param time [String;Time] time to expire order at
    #   Must be a string in format {YYYY-MM-DDThh:mm:ss±hh:mm} or
    #   anything responding to {strftime} message
    # @example
    #   op.order_expire = Time.now + 3600
    #   op.order_expire = 15.minutes.since
    def order_expire=(time)
      @order_expire =
        if time.respond_to? :strftime
          time.strftime('%FT%T%:z')
        else
          time.to_s
        end
    end

    private

    attr_reader :credentials

    # @return [Array<Symbol>] Operation input parameters
    def self.in_params
      raise NotImplementedError
    end

    def in_params
      self.class.in_params
    end

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
