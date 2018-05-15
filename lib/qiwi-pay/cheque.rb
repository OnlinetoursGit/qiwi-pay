# frozen_string_literal: true
require 'base64'
require 'zlib'
require 'json'

module QiwiPay
  # Чек 54-ФЗ
  class Cheque
    # @option params seller_id [Integer] ИНН организации, для которой пробивается чек
    # @option params cheque_type [Integer] Признак расчета (тэг 1054):
    #                                      1.  Приход
    #                                      2.  Возврат прихода
    #                                      3.  Расход
    #                                      4.  Возврат расхода
    # @option params customer_contact [String] Телефон или электронный адрес покупателя (тэг 1008)
    # @option params tax_system [Integer] Система налогообложения (тэг 1055):
    #                                     0 – Общая, ОСН
    #                                     1 – Упрощенная доход, УСН доход
    #                                     2 – Упрощенная доход минус расход, УСН доход - расход
    #                                     3 – Единый налог на вмененный доход, ЕНВД
    #                                     4 – Единый сельскохозяйственный налог, ЕСН
    #                                     5 – Патентная система налогообложения, Патент
    # @option params positions [Array<Hash>] Массив товаров
    def initialize(params)
      @json = JSON.fast_generate params
    end

    # @return [String] cheque as JSON
    # @example
    #   {
    #     "seller_id" : 3123011520,
    #     "cheque_type" : 1,
    #     "customer_contact" : "foo@domain.tld",
    #     "tax_system" : 1,
    #     "positions" : [
    #       {
    #         "quantity" : 2,
    #         "price" : 322.94,
    #         "tax" : 4,
    #         "description" : "Товар/Услуга 1"
    #       },
    #       {
    #         "quantity" : 1,
    #         "price" : 500,
    #         "tax" : 4,
    #         "description" : "Товар/Услуга 2"
    #       }
    #     ]
    #   }
    def to_json
      @json
    end

    # @return [String] Encoded cheque
    def encode
      Base64.strict_encode64(Zlib::Deflate.deflate(to_json))
    end
  end
end
