require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    mock_qiwi_pay_api_request
  end
end

def mock_qiwi_pay_api_request
  WebMock.stub_request(:post, %r{\Ahttps://acquiring\.qiwi\.com.+})
         .to_return(status: 200,
                    body: '{"txn_id":123, "txn_status":3, "txn_type":3,'\
                          '"txn_date": "2017-03-09T17:16:06+00:00",'\
                          '"error_code":0}')
end
