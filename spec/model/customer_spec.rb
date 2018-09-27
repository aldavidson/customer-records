require 'spec_helper'

require 'model/customer'

describe Customer do
  describe 'a new instance' do
    context 'given no arguments' do
      it 'has nil user_id' do
        expect(subject.user_id).to be_nil
      end
      it 'has nil name' do
        expect(subject.name).to be_nil
      end
      it 'has nil location' do
        expect(subject.location).to be_nil
      end
    end

    context 'given :user_id' do
      subject{ described_class.new(user_id: '12345') }

      it 'has the given user_id' do
        expect(subject.user_id).to eq('12345')
      end
    end

    context 'given :name' do
      subject{ described_class.new(name: 12345) }

      it 'has the given name' do
        expect(subject.name).to eq(12345)
      end
    end

    context 'given :location' do
      subject{ described_class.new(location: 12345) }

      it 'has the given location' do
        expect(subject.location).to eq(12345)
      end
    end

    context 'given no location' do
      context 'but given latitude & longitude' do
        let(:params) {
          {latitude: 123, longitude: 321}
        }

        describe 'the location attribute' do
          let(:location) { described_class.new(params).location }

          it 'is a Location' do
            expect(location).to be_a(Location)
          end

          it 'has the given latitude' do
            expect(location.latitude).to eq(123)
          end

          it 'has the given longitude' do
            expect(location.longitude).to eq(321)
          end
        end
      end
    end
  end

  describe '.from_json' do
    it 'parses the given string as JSON' do
      expect(JSON).to receive(:parse).with('given string').and_return({})
      described_class.from_json('given string')
    end

    context 'when it is valid JSON' do
      let(:parsed_json) {
        {'name' => 'aa', 'user_id' => '123'}
      }
      before do
        allow(JSON).to receive(:parse).and_return(parsed_json)
      end

      it 'creates a symbolized Hash with the parsed JSON' do
        expect(HashSymbolizer).to receive(:symbolize).with(parsed_json).and_return({})
        described_class.from_json('given string')
      end

      it 'returns a new Customer' do
        expect(described_class.from_json('anything')).to be_a(Customer)
      end

      describe 'the returned Customer' do
        let(:customer) { described_class.from_json('anything') }

        it 'has all the attributes given in the JSON' do
          expect(customer.user_id).to eq('123')
          expect(customer.name).to eq('aa')
        end
      end
    end
    context 'when it is valid JSON' do
      it 'raises a JSON::ParserError' do
        expect { described_class.from_json('invalid JSON') }.to raise_error(JSON::ParserError)
      end
    end
  end
end
