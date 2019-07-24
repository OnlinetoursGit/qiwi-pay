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

    describe 'receiving http error from QiwiPay' do
      before do
        WebMock.stub_request(:post, %r{\Ahttps://acquiring\.qiwi\.com.+})
               .to_return(status: 400,
                          body: '<html><head><title>400 The SSL certificate error</title></head>'\
                                '<body bgcolor="white"><center><h1>400 Bad Request</h1></center>'\
                                '<center>The SSL certificate error</center></body></html>')
      end

      it 'perform signed POST request to QiwiPay API URL' do
        r = subject.perform
        expect(r).to be_a QiwiPay::Api::Response
        expect(r.http_code).to eq 400
        expect(r.error_code).to eq -1
        expect(r.error_message).to include '400 The SSL certificate error'
      end

    end

    describe 'receiving timeout from QiwiPay' do
      before do
        WebMock.stub_request(:post, %r{\Ahttps://acquiring\.qiwi\.com.+}).to_timeout
      end

      it 'returns response with error description' do
        r = subject.perform
        expect(r).to be_a QiwiPay::Api::Response
        expect(r.http_code).to be_nil
        expect(r.error_code).to eq -1
        expect(r.error_message).to eq 'Timed out connecting to server'
      end
    end
  end
end
