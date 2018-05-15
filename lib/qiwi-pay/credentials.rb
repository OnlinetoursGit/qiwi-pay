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
    # @param p12 [String;OpenSSL::PKCS12] Container with key and certificate
    def initialize(secret:,
                   cert: nil,
                   key: nil,
                   key_pass: nil,
                   p12: nil)
      @secret = secret
      if p12
        @certificate, @key = load_p12(p12)
      else
        @certificate = create_cert(cert) if cert
        @key = create_key(key, key_pass) if key
      end
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

    def load_p12(p12_cont)
      p12 = case p12_cont
            when OpenSSL::PKCS12
              p12_cont
            else
              OpenSSL::PKCS12.new(File.read(p12_cont.to_s))
            end
      [p12.certificate, p12.key]
    end
  end
end
