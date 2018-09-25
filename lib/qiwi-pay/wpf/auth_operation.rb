# frozen_string_literal: true

module QiwiPay::Wpf
  # Авторизационный запрос (холдирование средств) в случае
  # двухшагового сценария оплаты
  class AuthOperation < PaymentOperation
    # Код операции auth
    def self.opcode
      3
    end

    # Описание операции
    def self.description
      'Авторизационный запрос (холдирование средств) в случае '\
      'двухшагового сценария оплаты'
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
