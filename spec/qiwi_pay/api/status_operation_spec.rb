RSpec.describe QiwiPay::Api::StatusOperation do
  let(:params) do
    {
      merchant_site: 123,
      txn_id: 1265,
      order_id: 'dsfkjdslkfjdlks'
    }
  end

  let(:ok_response_body) do
    <<-RESP
    {
      "transactions": [
        {
          "error_code": 0,
          "txn_id": 3666050,
          "txn_status": 2,
          "txn_type": 2,
          "txn_date": "2017-03-09T17:16:06+00:00",
          "pan": "400000******0002",
          "amount": 10000,
          "currency": 643,
          "auth_code": "181218",
          "merchant_site": 99,
          "card_name": "cardholder name",
          "card_bank": "",
          "order_id": "41324123412342"
        },
        {
          "error_code": 0,
          "txn_id": 3684050,
          "txn_status": 3,
          "txn_type": 4,
          "txn_date": "2017-03-09T17:16:09+00:00",
          "pan": "400000******0002",
          "amount": 100,
          "currency": 643,
          "merchant_site": 99,
          "card_name": "cardholder name",
          "card_bank": ""
        },
        {
          "error_code": 0,
          "txn_id": 3685050,
          "txn_status": 3,
          "txn_type": 4,
          "txn_date": "2017-03-19T17:16:06+00:00",
          "pan": "400000******0002",
          "amount": 100,
          "currency": 643,
          "merchant_site": 99,
          "card_name": "cardholder name",
          "card_bank": ""
        }
      ],
      "error_code": 0
    }
    RESP
  end
  let(:ok_response) { Struct.new(:code, :body).new(200, ok_response_body) }
  let(:api_client) { double('api_client') }

  subject { described_class.new credentials, params }

  describe '#perform' do
    before do
      allow(RestClient::Resource).to receive(:new).and_return(api_client)
    end

    describe 'making valid request' do
      it 'should make POST request with correct parameters' do
        expect(api_client).to receive(:post) do |params|
          expect(params).to eq '{"opcode":"30","merchant_site":"123","order_id":"dsfkjdslkfjdlks","sign":"30067d2400b2b012e31f9300ff2c8d609faf9400556a50a6bfb6ffca129991ac"}'
          ok_response
        end
        subject.perform
      end

      it 'should return api response object' do
        allow(api_client).to receive(:post).and_return(ok_response)
        r = subject.perform
        expect(r).to be_a QiwiPay::Api::Response
        expect(r.http_code).to eq ok_response.code
      end
    end

    describe 'making forbidden request' do
      it 'raises error' do
        expect(api_client).to receive(:post).and_raise(RestClient::Forbidden)
        expect { subject.perform }.to raise_error(RuntimeError)
      end
    end
  end
end
