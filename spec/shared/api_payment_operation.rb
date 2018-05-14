RSpec.shared_examples "api_payment_operation" do
  let(:params) do
    {
      merchant_site: 1234
    }
  end

  subject { described_class.new credentials, params }

  before do
    # Stub unimplemented method
    allow(subject).to receive(:opcode).and_return(0)
  end

  describe '#perform' do
    describe 'making request to QiwiPay API' do
      it 'perform signed POST request to QiwiPay API URL' do
        subject.perform
        expect(WebMock).to(
          have_requested(:post, 'https://acquiring.qiwi.com/merchant/direct').with do |req|
            req.body.include?('"opcode":"0"') &&
              req.body.include?('"merchant_site":"1234"') &&
              req.body.include?('"sign":')
          end
        )
      end

      it 'returns Response object with parsed data' do
        r = subject.perform
        expect(r).to be_a QiwiPay::Api::Response
        expect(r.http_code).to eq 200
        expect(r.error_code).to eq 0
        expect(r.txn_id).to eq 123
        expect(r.txn_status).to eq 3
        expect(r.txn_type).to eq 3
        expect(r.txn_date).to eq '2017-03-09T17:16:06+00:00'
      end
    end
  end
end
