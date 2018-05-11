# frozen_string_literal: true

module QiwiPay::Wpf
  # Авторизационный запрос (холдирование средств) в случае двухшагового сценария оплаты
  class AuthOperation < PaymentOperation
    # Код операции auth
    def self.opcode
      3
    end

    # Описание операции
    def self.description
      'Авторизационный запрос (холдирование средств) в случае двухшагового сценария оплаты'
    end
  end
end
