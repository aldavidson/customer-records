require 'spec_helper'

require 'lib/distance_calculator'

require 'model/location'

describe DistanceCalculator do
  describe '#to_rvincenty_location' do
    context 'given a Location' do
      let(:location) { Location.new(latitude: 123, longitude: 456) }

      it 'returns an array' do
        expect(described_class.to_rvincenty_location(location)).to be_a(Array)
      end

      describe 'the returned array' do
        let(:return_value) { described_class.to_rvincenty_location(location) }

        it 'has latitude first, then longitude' do
          expect(return_value).to eq( [location.latitude, location.longitude] )
        end
      end
    end
  end

  describe '#km_between' do
    context 'given two locations' do
      let(:location_1) { Location.new(latitude: 1.23, longitude: 4.56) }
      let(:location_2) { Location.new(latitude: 6.78, longitude: 2.34) }

      before do
        allow(RVincenty).to receive(:distance).and_return(9999.87)
        allow(described_class).to receive(:to_rvincenty_location)
                                  .with(location_1)
                                  .and_return('converted location 1')
        allow(described_class).to receive(:to_rvincenty_location)
                                  .with(location_2)
                                  .and_return('converted location 2')
      end

      it 'calls distance from the RVincenty class' do
        expect(RVincenty).to receive(:distance).and_return(9999.87)
        described_class.km_between(location_1, location_2)
      end

      it 'converts the given locations to rvincenty-compatible locations' do
        expect(described_class).to receive(:to_rvincenty_location).with(location_1)
        expect(described_class).to receive(:to_rvincenty_location).with(location_2)
        described_class.km_between(location_1, location_2)
      end

      it 'passes the converted locations to RVincenty' do
        expect(RVincenty).to receive(:distance).with('converted location 1', 'converted location 2')
        described_class.km_between(location_1, location_2)
      end

      it 'returns the RVincenty distance, divided by 1000.00' do
        expect(described_class.km_between(location_1, location_2)).to be_within(0.00001).of(9.99987)
      end
    end
  end
end
