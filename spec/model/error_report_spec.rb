require 'spec_helper'

require 'model/error_report'

describe ErrorReport do
  describe 'a new instance' do
    context 'given no arguments' do
      it 'has nil json' do
        expect(subject.json).to be_nil
      end
      it 'has nil line_number' do
        expect(subject.line_number).to be_nil
      end
      it 'has nil exception' do
        expect(subject.exception).to be_nil
      end
    end

    context 'given :json' do
      subject{ described_class.new(json: '12345') }

      it 'has the given json' do
        expect(subject.json).to eq('12345')
      end
    end

    context 'given :line_number' do
      subject{ described_class.new(line_number: 12345) }

      it 'has the given line_number' do
        expect(subject.line_number).to eq(12345)
      end
    end

    context 'given :exception' do
      subject{ described_class.new(exception: 12345) }

      it 'has the given exception' do
        expect(subject.exception).to eq(12345)
      end
    end
  end
end
