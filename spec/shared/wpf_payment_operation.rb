RSpec.shared_examples "wpf_payment_operation" do
  let(:params) do
    {
      merchant_site: 123,
      merchant_uid: 321
    }
  end

  subject { described_class.new credentials, params }

  describe '#params' do
    it 'returns hash of params for html form' do
      res = subject.params
      expect(res).to be_a Hash
      expect(res[:method]).to eq :get
      expect(res[:url]).to eq 'https://pay.qiwi.com/paypage/initial'
      expect(res[:opcode]).to eq described_class.opcode.to_s
      params.each do |k, v|
        expect(res[k].to_s).to eq v.to_s
      end
      expect(res).to have_key :sign
    end
  end

  describe '#url' do
    it 'returns QiwiPay form url' do
      url = subject.url
      expect(url).to start_with 'https://pay.qiwi.com/paypage/initial?'
      expect(url).to include "opcode=#{described_class.opcode}"
      expect(url).to include 'merchant_site=123'
      expect(url).to include 'merchant_uid=321'
      expect(url).to include '&sign='
    end
  end
end
