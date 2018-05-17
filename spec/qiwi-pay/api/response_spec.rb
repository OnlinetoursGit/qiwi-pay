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
  end
end
