RSpec.shared_examples "payment_operation" do
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

  # if amount parameter present
  if described_class.in_params.include? :amount
    it 'formats amount as currency' do
      expect(subject.amount).to eq '100.13'
    end
  end

  it 'requires https callback url' do
    expect do
      subject.callback_url = 'http://example.com/notify'
    end.to raise_error ArgumentError
  end

  describe '#request_params' do
    it 'returns hash with request parameters' do
      params = subject.send(:request_params)
      expect(params).to be_a Hash
      params_not_in_list = params.keys - described_class.in_params
      expect(params_not_in_list).to match_array %i[opcode sign]
    end

    it 'calculates signature parameter' do
      expect(subject.send(:request_params)[:sign]).to match /^[\dabcdef]+$/
    end
  end
end
