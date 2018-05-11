RSpec.describe QiwiPay::Confirmation do
  let(:params) do
    {
      txn_id: '20728960050',
      pan: '510621******3082',
      email: 'mklimenko@onlinetours.ru',
      country: 'RUS',
      city: 'Moscow',
      product_name: 'Оплата тура',
      ip: '196.54.55.20',
      order_id: 1232,
      txn_status: 1,
      txn_date: '2018-05-03T15:55:18+00:00',
      txn_type: 1,
      error_code: 8001,
      amount: '1000.00',
      currency: 643,
      sign: '27A56431CD3A14BA3455956766F772EA5732FC5E1C74541B33F58D7F7766D98A'
    }
  end
  let(:secret) { credentials.secret }
  subject { described_class.new secret, params }

  describe '#sign calculates signature for params' do
    it { expect(subject.send(:sign)).to eq params[:sign] }
  end

  describe '#valid_sign? tests signature for validity' do
    describe 'for valid signature' do
      it { expect(subject.valid_sign?).to be_truthy }
    end

    describe 'for invalid signature' do
      before { params[:sign] = 'invalidsignature' }
      it { expect(subject.valid_sign?).to be_falsy }
    end
  end

  describe '#success? tests operation for successfulness' do
    describe 'with no error' do
      before { params[:error_code] = '0' }

      describe 'with valid sign' do
        before { params[:sign] = '1E61076344971F540138D1107FB6E3E31A7E07EF811CE7E91F31178DF8EFDD5C' }
        it { expect(subject.success?).to be_truthy }
      end
      describe 'with invalid sign' do
        before { params[:sign] = 'invalidsignature' }
        it { expect(subject.success?).to be_falsy }
      end
    end

    describe 'with error present' do
      describe 'with valid sign' do
        it { expect(subject.success?).to be_falsy }
      end
      describe 'with invalid sign' do
        before { params[:sign] = 'invalidsignature' }
        it { expect(subject.success?).to be_falsy }
      end
    end
  end
end
