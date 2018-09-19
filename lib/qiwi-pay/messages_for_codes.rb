# frozen_string_literal: true

module QiwiPay
  # Модуль содержит константы и методы для получения расшифровок кодов
  module MessagesForCodes
    # Transaction status messages for codes
    # @see https://developer.qiwi.com/ru/qiwipay/index.html?json#txn_status
    TXN_STATUS_MESSAGES = {
      0 => 'Init',
      1 => 'Declined',
      2 => 'Authorized',
      3 => 'Completed',
      4 => 'Reconciled',
      5 => 'Settled'
    }.freeze

    # Transaction type messages for codes
    # @see https://developer.qiwi.com/ru/qiwipay/index.html?json#txn_type
    TXN_TYPE_MESSAGES = {
      1 => 'Single-step purchase',
      2 => 'Purchase: auth',
      6 => 'Single-step purchase: recurring init',
      7 => 'Purchase: recurring auth',
      4 => 'Reversal',
      3 => 'Refund',
      5 => 'Recurring',
      8 => 'Payout',
      0 => 'Unknown'
    }.freeze

    # Error messages for codes
    # @see https://developer.qiwi.com/ru/qiwipay/index.html?json#errors
    ERROR_MESSAGES = {
      0    => 'No errors',
      8001 => 'Internal error',
      8002 => 'Operation not supported',
      8004 => 'Temporary error',
      8005 => 'Route not found',
      8006 => 'Card not supported',
      8018 => 'Parsing error',
      8019 => 'Validation error',
      8020 => 'Amount too big',
      8021 => 'Merchant site not found',
      8022 => 'Transaction not found',
      8023 => 'Transaction expired',
      8025 => 'Opcode is not allowed',
      8026 => 'Incorrect parent transaction status',
      8027 => 'Incorrect parent transaction type',
      8028 => 'Card expired',
      8051 => 'Merchant disabled',
      8052 => 'Incorrect transaction state',
      8054 => 'Invalid signature',
      8055 => 'Order already payed',
      8056 => 'In process',
      8057 => 'Card locked',
      8058 => 'Access denied',
      8059 => 'Currency is not allowed',
      8060 => 'Amount too big',
      8061 => 'Currency mismatch',
      8151 => 'Authentification failed',
      8152 => 'Transaction rejected by security service',
      8160 => 'Transaction rejected: try again',
      8161 => 'Transaction rejected: try again',
      8162 => 'Transaction rejected: try again',
      8163 => 'Transaction rejected: contact QIWI support',
      8164 => 'Transaction rejected: not enought funds, contact card issuer',
      8165 => 'Transaction rejected: wrong payment details',
      8166 => 'Transaction rejected: wrong card details',
      8167 => 'Transaction rejected: wrong card details',
      8168 => 'Transaction rejected: prohibited, contact card issuer'
      8169 => 'Transaction rejected: not enought funds'
    }.freeze

    # Transaction status description
    # @return [String]
    def txn_status_message
      return unless txn_status
      TXN_STATUS_MESSAGES[txn_status.to_i] || 'Unknown status'
    end

    # Transaction type description
    # @return [String]
    def txn_type_message
      return unless txn_type
      TXN_TYPE_MESSAGES[txn_type.to_i] || 'Unknown type'
    end

    # Error description for code
    # @return [String]
    def error_message
      return unless error_code
      ERROR_MESSAGES[error_code.to_i] || 'Unknown error'
    end
  end
end
