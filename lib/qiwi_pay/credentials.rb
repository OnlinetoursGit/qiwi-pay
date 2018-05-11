# frozen_string_literal: true

require 'openssl'

module QiwiPay
  # QiwiPay access credentials
  class Credentials
    # @return [String]
    attr_reader :secret

    # @return [OpenSSL::X509::Certificate]
    attr_reader :certificate

    # @return [OpenSSL::PKey::RSA]
    attr_reader :key

    # @param secret [String] Secret for signature calculation
    # @param cert [String;OpenSSL::X509::Certificate] Certificate for API auth
    # @param key [String;OpenSSL::PKey::RSA] Private key for certificate for API auth
    # @param key_pass [String] Private key passphrase
    def initialize(secret:,
                   cert: nil,
                   key: nil,
                   key_pass: nil)
      @secret = secret
      @certificate = create_cert(cert) if cert
      @key = create_key(key, key_pass) if key
    end

    private

    def create_cert(cert)
      case cert
      when OpenSSL::X509::Certificate
        cert
      else
        OpenSSL::X509::Certificate.new(File.read(cert.to_s))
      end
    end

    def create_key(key, key_pass = nil)
      case key
      when OpenSSL::PKey::RSA
        key
      else
        OpenSSL::PKey::RSA.new(File.read(key.to_s), key_pass)
      end
    end
  end
end
