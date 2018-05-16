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
  subject { described_class.new credentials, params }

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

  describe '#success? and #error? test operation for successfulness' do
    describe 'with no error' do
      before { params[:error_code] = '0' }

      describe 'with valid sign' do
        before { params[:sign] = '1E61076344971F540138D1107FB6E3E31A7E07EF811CE7E91F31178DF8EFDD5C' }
        it { expect(subject.success?).to be_truthy }
        it { expect(subject.error?).to be_falsy }
      end
      describe 'with invalid sign' do
        before { params[:sign] = 'invalidsignature' }
        it { expect(subject.success?).to be_falsy }
        it { expect(subject.error?).to be_falsy }
      end
    end

    describe 'with error present' do
      describe 'with valid sign' do
        it { expect(subject.success?).to be_falsy }
        it { expect(subject.error?).to be_truthy }
      end
      describe 'with invalid sign' do
        before { params[:sign] = 'invalidsignature' }
        it { expect(subject.success?).to be_falsy }
        it { expect(subject.error?).to be_truthy }
      end
    end
  end

  describe 'with creepy hash as params' do
    let(:params) { Hash.new(:some_val) }

    before do
      params[:txn_id] = 20728960050
      params[:email] = 'mklimenko@onlinetours.ru'
    end

    it 'extracts params' do
      expect(subject.txn_id).to eq params[:txn_id]
      expect(subject.email).to eq params[:email]
    end
  end

  describe 'with string params values given' do
    let(:params) { Hash.new(:some_val) }

    before do
      params[:txn_id] = '20728960050'
      params[:txn_status] = '1'
      params[:txn_type] = '2'
      params[:currency] = '643'
      params[:error_code] = '11'
      params[:email] = 'mklimenko@onlinetours.ru'
    end

    it 'converts certain valuest to integer' do
      expect(subject.txn_id).to eq params[:txn_id].to_i
      expect(subject.txn_status).to eq params[:txn_status].to_i
      expect(subject.txn_type).to eq params[:txn_type].to_i
      expect(subject.currency).to eq params[:currency].to_i
      expect(subject.error_code).to eq params[:error_code].to_i
      expect(subject.email).to eq params[:email]
    end
  end
end
