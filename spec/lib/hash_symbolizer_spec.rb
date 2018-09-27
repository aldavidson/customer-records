require 'spec_helper'

require 'lib/hash_symbolizer'

describe HashSymbolizer do
  describe '.symbolize' do
    context 'given a Hash' do
      let(:hash) {  {a: 'aa', b: 'bb', 'c' => 'cc', 'd' => 'dd'}}

      describe 'the return value' do
        let(:return_value) { described_class.symbolize(hash) }

        it 'is a Hash' do
          expect(return_value).to be_a(Hash)
        end

        it 'has all string keys converted to symbol keys' do
          expect(return_value).to eq({a: 'aa', b: 'bb', c: 'cc', d: 'dd'})
        end
      end
    end
  end
end
