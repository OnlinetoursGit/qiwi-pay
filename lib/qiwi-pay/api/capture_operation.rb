# frozen_string_literal: true

module QiwiPay::Api
  # Подтверждение авторизации в случае двухшагового сценария оплаты
  #
  # @note Параметры запроса
  #   merchant_site Обязательно integer  Идентификатор сайта ТСП
  #   txn_id        Обязательно integer  Идентификатор транзакции
  #   cheque        Опционально string   Данные для кассового чека по 54-ФЗ
  #
  # @example Запрос
  #   {
  #     "opcode": 5,
  #     "merchant_site": 99,
  #     "txn_id": "172001",
  #     "sign": "bb5c48ea540035e6b7c03c8184f74f09d26e9286a9b8f34b236b1bf2587e4268"
  #   }
  #
  # @example Ответ
  #   {
  #     "txn_id":172001,
  #     "txn_status":3,
  #     "txn_type":2,
  #     "txn_date": "2017-03-09T17:16:06+00:00",
  #     "error_code":0
  #   }
  class CaptureOperation < PaymentOperation
    # Код операции sale
    def self.opcode
      5
    end

    # Описание операции
    def self.description
      'Подтверждение авторизации в случае двухшагового сценария оплаты'
    end

    private

    def self.in_params
      %i[merchant_site txn_id cheque].freeze
    end
  end
end
