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
  end
end
