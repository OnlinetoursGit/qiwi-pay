RSpec.describe QiwiPay::Signature do
  subject { described_class.new(params, 'secret') }
  let(:params) { { b: :b, zzz: :zzz, cdf: :cdf, abc: :abc, 'asd' => 'asd' } }
  let(:signature) { 'd6575188a24edb6960d7f63564f3f5c0752553b6d4f305d12f4d39c00ee5f0a4' }

  describe '#build_params_string' do
    subject { described_class.new(params, 'secret').send(:build_params_string) }

    it 'builds string from param values ordered by keys joined with bar' do
      expect(subject).to eq 'abc|asd|b|cdf|zzz'
    end

    it 'should reject blank values' do
      params[:abc] = nil
      params[:zzz] = ''
      expect(subject).to eq 'asd|b|cdf'
    end

    it 'should ignore `sign` parameter' do
      params[:sign] = 'sign1'
      params['sign'] = 'sign2'
      expect(subject).to eq 'abc|asd|b|cdf|zzz'
    end

    it 'should ignore `cheque` parameter' do
      params[:cheque] = 'cheque1'
      params['cheque'] = 'cheque2'
      expect(subject).to eq 'abc|asd|b|cdf|zzz'
    end

    it 'should ignore `merchant_cheque` parameter' do
      params[:merchant_cheque] = 'cheque1'
      params['merchant_cheque'] = 'cheque2'
      expect(subject).to eq 'abc|asd|b|cdf|zzz'
    end

    it 'preserves input params value' do
      params[:sign] = 'sign1'
      params[:cheque] = 'cheque1'
      params['merchant_cheque'] = 'cheque2'
      params_before = Marshal.load( Marshal.dump(params) )
      subject
      expect(params).to eq params_before
    end
  end

  describe '#sign' do
    it 'calculates signature' do
      expect(subject.sign).to eq signature
    end
  end
end
