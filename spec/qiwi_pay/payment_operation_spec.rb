RSpec.describe QiwiPay::PaymentOperation do
  let(:params) do
    {
      merchant_site: 1234,
      currency: 643,
      amount: 100.134,
      abra_kadabra: 'abracadabra',
      cheque: 'asdljhaskjdhkajsdhkaj',
      callback_url: 'https://example.com/notify'
    }
  end
  let(:sign) { 'ab8543951d8ace7d4e828a1611cd8576d10b2f83d8d5298a3599b587d90515ac' }
  subject { described_class.new credentials, params }

  describe 'constructor' do
    it 'assigns parameters to attributes' do
      expect(subject.merchant_site).to eq 1234
    end

    it 'does not assign unknow attributes' do
      expect(subject.instance_variable_get(:@abra_kadabra)).to be_nil
      expect { subject.abra_kadabra }.to raise_error NoMethodError
    end

    it 'memoizes credentials internally' do
      expect(subject.instance_variable_get(:@credentials)).to be_a QiwiPay::Credentials
      expect { subject.secret }.to raise_error NoMethodError
    end
  end

  it 'formats amount as currency' do
    expect(subject.amount).to eq '100.13'
  end

  it 'requires https callback url' do
    expect do
      subject.callback_url = 'http://example.com/notify'
    end.to raise_error ArgumentError

  end

  describe '#request_params' do
    before do
      subject.instance_eval { define_singleton_method :opcode, -> { 1 } }
    end

    it 'returns hash with request parameters' do
      params = subject.send(:request_params)
      expect(params).to be_a Hash
      expect(params.keys).to match_array %i[amount
                                            cheque
                                            currency
                                            merchant_site
                                            opcode
                                            callback_url
                                            sign]
    end

    it 'calculates signature parameter' do
      expect(subject.send(:request_params)[:sign]).to eq sign
    end
  end
end
