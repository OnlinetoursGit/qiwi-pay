require 'qiwi-pay'
require_relative 'support/external_requests'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def credentials
  QiwiPay::Credentials.new secret: :secret,
                           cert: OpenSSL::X509::Certificate.new,
                           key: OpenSSL::PKey::RSA.new
end
