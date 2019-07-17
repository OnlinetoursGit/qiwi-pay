RSpec.describe QiwiPay::Api::Response do
  let(:json) { '{"txn_id":"123", "error_code":"0", "c":"ttt"}' }
  let(:http_code) { 200 }
  subject { described_class.new http_code, json }

  describe '#new' do
    it { expect(subject).to be_success }

    it 'converts integer attributes to integer' do
      expect(subject.txn_id).to eq 123
      expect(subject.error_code).to eq 0
    end

    describe 'received `http_code` parameter in json' do
      let(:json) { '{"txn_id":"123", "http_code":100500}' }
      it 'returns valid http_code' do
        expect(subject.http_code).to eq 200
      end
    end

    describe 'received HTTP body with error description' do
      let(:http_code) { 400 }
      let(:json) do
        '<html><head><title>400 The SSL certificate error</title></head>'\
        '<body bgcolor="white"><center><h1>400 Bad Request</h1></center>'\
        '<center>The SSL certificate error</center></body></html>'
      end

      its(:http_code) { is_expected.to eq 400 }
      its(:error_code) { is_expected.to eq -1 }
      its(:error_message) { is_expected.to include '400 The SSL certificate error' }
    end
  end
end
