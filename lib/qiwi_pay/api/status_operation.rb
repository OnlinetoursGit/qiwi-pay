# frozen_string_literal: true

module QiwiPay::Api
  # Запрос статуса операции
  #
  # @note Параметры запроса
  #   merchant_site Обязательно integer     Идентификатор сайта ТСП
  #   txn_id        Опционально integer     Идентификатор транзакции
  #   order_id      Опционально string(256) Уникальный номер заказа в системе ТСП
  #
  # @example Запрос
  #   {
  #     "opcode":30,
  #     "merchant_site": 99,
  #     "order_id": "41324123412342",
  #     "sign": "bb5c48ea540035e6b7c03c8184f74f09d26e9286a9b8f34b236b1bf2587e4268"
  #   }
  #
  # @example Ответ
  #   {
  #     "transactions": [
  #       {
  #         "error_code": 0,
  #         "txn_id": 3666050,
  #         "txn_status": 2,
  #         "txn_type": 2,
  #         "txn_date": "2017-03-09T17:16:06+00:00",
  #         "pan": "400000******0002",
  #         "amount": 10000,
  #         "currency": 643,
  #         "auth_code": "181218",
  #         "merchant_site": 99,
  #         "card_name": "cardholder name",
  #         "card_bank": "",
  #         "order_id": "41324123412342"
  #       },
  #       {
  #         "error_code": 0,
  #         "txn_id": 3684050,
  #         "txn_status": 3,
  #         "txn_type": 4,
  #         "txn_date": "2017-03-09T17:16:09+00:00",
  #         "pan": "400000******0002",
  #         "amount": 100,
  #         "currency": 643,
  #         "merchant_site": 99,
  #         "card_name": "cardholder name",
  #         "card_bank": ""
  #       },
  #       {
  #         "error_code": 0,
  #         "txn_id": 3685050,
  #         "txn_status": 3,
  #         "txn_type": 4,
  #         "txn_date": "2017-03-19T17:16:06+00:00",
  #         "pan": "400000******0002",
  #         "amount": 100,
  #         "currency": 643,
  #         "merchant_site": 99,
  #         "card_name": "cardholder name",
  #         "card_bank": ""
  #       }
  #     ],
  #     "error_code": 0
  #   }
  class StatusOperation < PaymentOperation
    # Код операции sale
    def self.opcode
      30
    end

    # Описание операции
    def self.description
      'Запрос статуса операции'
    end

    private

    def self.in_params
      %i[merchant_site txn_id order_id].freeze
    end
  end
end
