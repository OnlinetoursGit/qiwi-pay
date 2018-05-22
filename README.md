# QiwiPay

QiwiPay WPF/API binding for Ruby.

Provides support for payment operations using QiwiPay WPF and API services.

See [Official QiwiPay documentation](https://developer.qiwi.com/ru/qiwipay) for detailed API description.

## Table of contents

  *  [Installation](#installation)
  *  [Usage](#usage)
      * [Prepare credentials object](#prepare-credentials-object)
      * [Create cheque object](#create-cheque-object)
      * [Perform payment operations using WPF](#perform-payment-operations-using-wpf)
      * [Process QiwiPay confirmation callback](#process-qiwipay-confirmation-callback)
      * [Perform payment operations using JSON API](#perform-payment-operations-using-json-api)
  * [Development](#development)
  * [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qiwi-pay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qiwi-pay


## Usage

There are three types of interactions with QiwiPay service:

1. Performing Web Payment Form requests
2. Performing JSON API requests
3. Handling callback confirmation requests

### Prepare credentials object
To perform any request you must provide your QiwiPay credentials. For doing that the `Credentials` object should be used.

```ruby
# Create credentials object
# You can use PKCS#12 container
p12 = OpenSSL::PKCS12.new(File.read('qiwi.p12'))

crds = QiwiPay::Credentials.new secret: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
                                p12: p12

# ... or provide certificate and key objects explicitly
crds = QiwiPay::Credentials.new secret: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
                                cert: p12.certificate,
                                key: p12.key

# ... or load from separate files
crds = QiwiPay::Credentials.new secret: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
                                cert: 'my.crt',
                                key: 'my.key'
```

### Create cheque object

See [Cheque section of Official QiwiPay documentation](https://developer.qiwi.com/ru/qiwipay/index.html?json#cheque) for details.
```ruby
cheque = QiwiPay::Cheque.new seller_id:        12345678901,
                             cheque_type:      QiwiPay::Cheque::Type::INFLOW,
                             customer_contact: 'client@example.com',
                             tax_system:       QiwiPay::Cheque::TaxMode::USN_DR,
                             positions: [{
                                quantity:    1,
                                price:       10_000,
                                tax:         QiwiPay::Cheque::VAT::NONE,
                                description: 'Order #1234 payment'
                             }]
```

### Perform payment operations using WPF
Only two types of payment operations are available for now:
* *sale* - single-step payment operation
* *auth* - initiate multi-steps payment operation

Operations are used in very similar way. Use `QiwiPay::Wpf::SaleOperation` class for *sale* operation and `QiwiPay::Wpf::AuthOperation` class for *auth* operation.

See [WPF section of Official QiwiPay documentation](https://developer.qiwi.com/ru/qiwipay/index.html?json#qiwipay-wpf) for details.

#### Create payment operation object
```ruby
op = QiwiPay::Wpf::SaleOperation.new crds,
                                     merchant_site: 111_111,
                                     currency: 643,
                                     email: 'client@example.com',
                                     country: 'RUS',
                                     city: 'Moscow',
                                     amount: 10_000,
                                     order_id: 1234,
                                     product_name: 'Flowers',
                                     merchant_uid: 432101,
                                     order_expire: Time.now + 3600,
                                     callback_url: 'https://example.com/payment/callback'
op.cheque = cheque
```

#### Build redirection URL for sale operation form
```ruby
op.url
=> 'https://pay.qiwi.com/paypage/initial?opcode=1&merchant_site=111111&currency=643&amount=1000.00&order_id=1234&email=client@example.com&country=RUS&city=Moscow&product_name=%D0%9E%D0%BF%D0%BB%D0%B0%D1%82%D0%B0+%D1%82%D1%83%D1%80%D0%B0&merchant_uid=432101&callback_url=https%3A%2F%example.com%2Fpayment%2Fcallback&sign=...c4dbf...'
```

#### Build form params WPF sale operation
This may be useful if you would like to construct redirection URL or invisible payment form by yourself.
```ruby
op.params
=> {:method=>:get,
 :url=>"https://pay.qiwi.com/paypage/initial",
 :opcode=>"1",
 :merchant_site=>"111111",
 :currency=>"643",
 :amount=>"1000.00",
 :order_id=>"1234",
 :email=>"client@example.com",
 :country=>"RUS",
 :city=>"Moscow",
 :product_name=>"Flowers",
 :merchant_uid=>"432101",
 :callback_url=>"https://example.com/payment/callback",
 :sign=>"...c4dbf..."}
```

### Process QiwiPay confirmation callback
After payment operation has been finished you will receive a confirmation callback request from Qiwi service. Use the request's (`ActionDispatch::Request`, `Rack::Request` or whatever it is) parameters hash to build `QiwiPay::Confirmation` object.

```ruby
conf = QiwiPay::Confirmation.new crds, request.params
```

Now you have a seamless way to access confirmation data and perform some tests on it.

```ruby
# Check if ip address is a valid Qiwi server address
conf.valid_server_ip? request.ip
=> true

# Check signature
conf.valid_sign?
=> true

# Read confirmation data
conf.txn_id
=> 11728960050

conf.order_id
=> 1234

conf.error_code
=> 0

conf.error_message
=> "No error"

conf.error?
=> false

conf.txn_status_message
=> "Authorized"

conf.txn_type_message
=> "Purchase: auth"

# Check if transaction was successful (valid signature and no error)
conf.success?
=> true

# Get all confirmation data as a hash
conf.to_h
=> {:txn_id=>11728960050,
 :txn_status=>2,
 :txn_type=>1,
 :txn_date=>"2018-05-03T15:55:18+00:00",
 :error_code=>0,
 :pan=>"510000******0082",
 :amount=>"10000.00",
 :currency=>643,
 :auth_code=>nil,
 :eci=>nil,
 :card_name=>nil,
 :card_bank=>nil,
 :order_id=>1234,
 :ip=>"196.54.55.20",
 :email=>"client@example.com",
 :country=>"RUS",
 :city=>"Moscow",
 :region=>nil,
 :address=>nil,
 :phone=>nil,
 :cf1=>nil,
 :cf2=>nil,
 :cf3=>nil,
 :cf4=>nil,
 :cf5=>nil,
 :product_name=>"Flowers",
 :card_token=>nil,
 :card_token_expire=>nil,
 :sign=>"27A56431CD3A14BA34...8A",
 :txn_status_message=>"Authorized",
 :txn_type_message=>"Single-step purchase"}
```

### Perform payment operations using JSON API
Following operations are available for now:

* *capture* - `QiwiPay::Api::CaptureOperation` class
* *refund* - `QiwiPay::Api::RefundOperation` class
* *reversal* - `QiwiPay::Api::ReversalOperation` class
* *status* - `QiwiPay::Api::StatusOperation` class

#### Status operation
##### Create and perform `status` operation object
```ruby
op = QiwiPay::Api::StatusOperation.new crds,
                                       merchant_site: 111111,
                                       txn_id: 11728960050,
                                       order_id: 1234
response = op.perform
```

Operations' `perform` methods return `QiwiPay::Api::Response` object. It allow you to get text messages for errors, codes and statuses. See [Transaction statuses section of Official QiwiPay documentation](https://developer.qiwi.com/ru/qiwipay/index.html?json#txn_status)

##### Operation succeeded
```ruby
response.success?
=> true
response.error_code
=> 0
response.error_message
=> "No errors"
```

##### Operation failed
```ruby
response.success?
=> false
response.http_code
=> 200
response.error_code
=> 8021
response.error_message
=> "Merchant site not found"
```

#### Refund/reversal operation
Both operations are performed in the same way, just use the right class.

```ruby
op = QiwiPay::Api::RefundOperation.new crds,
                                       merchant_site: 111111,
                                       txn_id: 11728960050,
                                       amount: 500,
                                       cheque: cheque
response = op.perform
=> #<QiwiPay::Api::Response http_code=200 error_code=8018 ...>
response.success?
=> false
response.http_code
=> 200
response.error_code
=> 8018
response.error_message
=> "Parsing error"
response.to_h
=> {:request_id => "01234567-89ab-cdef-0123-456789abcdef",
 :error_message => "Parsing error",
 :error_code => 8018,
 :http_code => 200
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` or `rake console` or `rake c` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/OnlinetoursGit/qiwi-pay.
