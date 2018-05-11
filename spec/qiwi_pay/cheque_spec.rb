RSpec.describe QiwiPay::Cheque do
  let(:params) {
    {
      seller_id: 3123011520,
      cheque_type: 1,
      customer_contact: "foo@domain.tld",
      tax_system: 1,
      positions: [
        {
          quantity: 2,
          price: 322.94,
          tax: 4,
          description: "Товар/Услуга 1"
        },
        {
          quantity: 1,
          price: 500,
          tax: 4,
          description: "Товар/Услуга 2"
        }
      ]
    }
  }
  subject{ described_class.new params }

  describe '#to_json' do
    it 'returns JSON' do
      json = subject.to_json
      expect{JSON.parse(json)}.not_to raise_error
    end

    it 'includes required parameters' do
      json = subject.to_json
      expect(json).to include 'seller_id'
      expect(json).to include 'cheque_type'
      expect(json).to include 'customer_contact'
      expect(json).to include 'tax_system'
      expect(json).to include 'positions'
    end
  end

  describe '#encode' do
    it 'returns a string' do
      expect(subject.encode).to be_a String
    end

    it 'encode string properly' do
      data = Base64.strict_encode64(Zlib::Deflate.deflate(subject.to_json))
      expect(subject.encode).to eq data
    end
  end
end
