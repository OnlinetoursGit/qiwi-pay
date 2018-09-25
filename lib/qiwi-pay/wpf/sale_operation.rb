# frozen_string_literal: true

module QiwiPay::Wpf
  # Одношаговый сценарий оплаты
  class SaleOperation < PaymentOperation
    # Код операции sale
    def self.opcode
      1
    end

    # Описание операции
    def self.description
      'Одношаговый сценарий оплаты'
    end

    private

    def self.in_params
      %i[
        merchant_site currency amount order_id
        email country city region address phone
        cf1 cf2 cf3 cf4 cf5
        product_name merchant_uid modifiers card_token order_expire
        callback_url success_url decline_url
        merchant_cheque
      ].freeze
    end
  end
end
