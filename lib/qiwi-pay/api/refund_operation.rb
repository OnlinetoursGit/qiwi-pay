# frozen_string_literal: true

module QiwiPay::Api
  # Операция возврата платежа (средства возвращаются в течение 30 дней)
  #
  # @note Параметры запроса
  #   merchant_site Обязательно integer    Идентификатор сайта ТСП
  #   txn_id        Обязательно integer    Идентификатор транзакции
  #   amount        Опционально string(20) Сумма операции
  #   cheque        Опционально string     Данные для кассового чека по 54-ФЗ
  #
  # @example Запрос
  #   {
  #     "opcode":7,
  #     "merchant_site": 99,
  #     "txn_id": 181001,
  #     "amount": "700",
  #     "sign": "bb5c48ea540035e6b7c03c8184f74f09d26e9286a9b8f34b236b1bf2587e4268"
  #   }
  #
  # @example Ответ
  #   {
  #     "txn_id":182001,
  #     "txn_status":3,
  #     "txn_type":3,
  #     "txn_date": "2017-03-09T17:16:06+00:00",
  #     "error_code":0,
  #     "amount": 700
  #   }
  class RefundOperation < PaymentOperation
    # Код операции sale
    def self.opcode
      7
    end

    # Описание операции
    def self.description
      'Возврат платежа'
    end

    private

    def self.in_params
      %i[merchant_site txn_id amount cheque].freeze
    end
  end
end
