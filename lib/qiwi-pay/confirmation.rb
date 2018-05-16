# frozen_string_literal: true

module QiwiPay
  # Qiwi payment confirmation (callback)
  #
  # @note Confirmation parameters list
  #   Параметр          Тип данных  Описание
  #   txn_id            integer     Идентификатор транзакции
  #   txn_status        integer     Статус транзакции
  #   txn_type          integer     Тип транзакции
  #   txn_date          timestamp   Дата транзакции в формате ISO8601 с временной зоной
  #   error_code        integer     Код ошибки работы системы
  #   pan               string(19)  Номер карты Покупателя в формате 411111XXXXXX1111
  #   amount            decimal     Сумма списания
  #   currency          integer     Валюта суммы списания в цифровом формате согласно ISO 4217
  #   auth_code         string(6)   Код авторизации
  #   eci               string(2)   Индикатор E-Commerce операции
  #   card_name         string(64)  Имя Покупателя, как указано на карте (латинские буквы)
  #   card_bank         string(64)  Банк-эмитент карты
  #   order_id          string(256) Уникальный номер заказа в системе ТСП
  #   ip                string(15)  IP-адрес Покупателя
  #   email             string(64)  E-mail Покупателя
  #   country           string(3)   Страна Покупателя в формате 3-х буквенных кодов согласно ISO 3166-1
  #   city              string(64)  Город местонахождения Покупателя
  #   region            string(6)   Регион страны формате геокодов согласно ISO 3166-2
  #   address           string(64)  Адрес местонахождения Покупателя
  #   phone             string(15)  Контактный телефон Покупателя
  #   cf1               string(256) Поля для ввода произвольной информации, дополняющей данные по операции. Например - описание услуг ТСП.
  #   cf2               string(256) Поля для ввода произвольной информации, дополняющей данные по операции. Например - описание услуг ТСП.
  #   cf3               string(256) Поля для ввода произвольной информации, дополняющей данные по операции. Например - описание услуг ТСП.
  #   cf4               string(256) Поля для ввода произвольной информации, дополняющей данные по операции. Например - описание услуг ТСП.
  #   cf5               string(256) Поля для ввода произвольной информации, дополняющей данные по операции. Например - описание услуг ТСП.
  #   product_name      string(256) Описание услуги которую получает Плательщик.
  #   card_token        string(40)  Токен карты (если функционал токенизации включен для данного сайта)
  #   card_token_expire timestamp   Срок истечения токена карты (если функционал токенизации включен для данного сайта)
  #   sign              string(64)  Контрольная сумма переданных параметров. Контрольная сумма передается в верхнем регистре.
  #
  # @note {timestamp} data type is represented by string in format {YYYY-MM-DDThh:mm:ss±hh:mm}
  class Confirmation
    include QiwiPay::MessagesForCodes

    # Available confirmation parameters
    ALLOWED_PARAMS = %i[
      txn_id txn_status txn_type txn_date error_code pan
      amount currency auth_code eci card_name card_bank
      order_id ip email country city region address phone
      cf1 cf2 cf3 cf4 cf5
      product_name
      card_token card_token_expire
      sign
    ].freeze

    # Parameters of integer type
    INTEGER_PARAMS = %i[
      txn_id
      txn_status
      txn_type
      error_code
      currency
    ]

    # Request params used to calculate signature
    SIGN_PARAMS = %i[
      txn_id
      txn_status
      txn_type
      error_code
      amount
      currency
      ip
      email
    ].freeze

    # IPs allowed to receive confirmation from
    ALLOWED_IPS = %w[
      91.232.231.36
      79.142.22.81
      79.142.28.154
      195.189.102.81
    ].freeze

    attr_reader(*ALLOWED_PARAMS)
    attr_reader :secret

    # @param crds [Credentials] Api access credentials object
    # @param params [Hash] Request params
    def initialize(crds, params)
      ALLOWED_PARAMS.each do |pname|
        pval = params.fetch(pname, nil) || params.fetch(pname.to_s, nil)
        pval = pval.to_i if INTEGER_PARAMS.include?(pname)
        instance_variable_set "@#{pname}", pval
      end
      @secret = crds.secret
    end

    # Check server IP address validity
    # @param ip [String]
    # @return [Boolean]
    def valid_server_ip?(ip)
      ALLOWED_IPS.include? ip
    end

    # Check confirmation params signature validity
    # @return [Boolean]
    def valid_sign?
      calculated_sign.upcase == sign
    end

    # Check if payment operation was successful
    def success?
      valid_sign? && !error?
    end

    # Check if error code present in response
    def error?
      !error_code.zero?
    end

    private

    # Calculates signature for parameters
    def calculated_sign
      params = SIGN_PARAMS.each_with_object({}) do |p, h|
        h[p] = send(p).tap { |v| v ? v.to_s : nil }
      end
      Signature.new(params, @secret).sign.upcase
    end
  end
end
