require 'spec_helper'

require 'app'

describe App do
  describe '#report_results' do
    let(:mock_stdout) { double('stdout', puts: true, :<< => true) }
    let(:mock_stderr) { double('stderr', puts: true, :<< => true) }

    it 'puts a header to the given stdout' do
      expect(mock_stdout).to receive(:puts).with("Customers within 100km of the Dublin Office:")
      subject.report_results(mock_stdout, mock_stderr)
    end

    it 'outputs the formatted customers_to_invite to the given stdout' do
      expect_any_instance_of(ResultFormatter).to receive(:customers_to_invite).with(mock_stdout)
      subject.report_results(mock_stdout, mock_stderr)
    end

    context 'when there are errors' do
      before do
        subject.result.errors << ErrorReport.new(
          line_number: 1,
          json: 'json 1',
          exception: double("exception", message: 'exception message')
        )
      end

      it 'puts a header to the given stderr' do
        expect(mock_stderr).to receive(:puts).with("Lines that couldn't be parsed:")
        subject.report_results(mock_stdout, mock_stderr)
      end

      it 'outputs the formatted error to the given stderr' do
        expect_any_instance_of(ResultFormatter).to receive(:errors).with(mock_stderr)
        subject.report_results(mock_stdout, mock_stderr)
      end
    end
  end

  describe '#process_line!' do
    let(:mock_customer) { instance_double(Customer, location: 'mock location') }
    let(:distance) { 804.672 }
    before do
      allow(DistanceCalculator).to receive(:km_between).and_return(distance)
      allow(Customer).to receive(:from_json).and_return(mock_customer)
    end

    it 'creates a Customer from the given json' do
      expect(Customer).to receive(:from_json).with('given line').and_return(mock_customer)
      subject.process_line!('given line')
    end

    it 'asks the DistanceCalculator to calculate distance between the Dublin office and the customers location' do
      expect(DistanceCalculator).to receive(:km_between).with(App::DUBLIN_OFFICE, 'mock location').and_return(804.672)
      subject.process_line!('given line')
    end

    context 'when the distance is within 100km' do
      let(:distance) { 99.9 }

      it 'adds the customer to the customers_to_invite list in the result' do
        expect{ subject.process_line!('given line') }.to change(subject.result.customers_to_invite, :count).by(1)
      end
    end

    context 'when the distance is more than 100km' do
      let(:distance) { 101 }

      it 'does not add the customer to the customers_to_invite list in the result' do
        expect{ subject.process_line!('given line') }.to_not change(subject.result.customers_to_invite, :count)
      end
    end
  end

  describe 'run!' do
    let(:filename) { 'mock file name'}
    let(:mock_file) { double(File, each_line: ['line1', 'line2']) }
    subject { described_class.new(options: {filename: filename}) }
    before do
      allow(File).to receive(:open).with(filename, 'r').and_return(mock_file)
    end

    it 'opens the given file in read-only mode' do
      expect(File).to receive(:open).with(filename, 'r').and_return(mock_file)
      subject.run!
    end

    context 'for each line' do
      before do
        allow(mock_file).to receive(:each_line).and_yield('line1')
      end

      it 'processes the line' do
        expect(subject).to receive(:process_line!).with('line1')
        subject.run!
      end

      context 'when processing the line raises a JSON::ParserError' do
        before do
          allow(subject).to receive(:process_line!).and_raise(JSON::ParserError, message: 'error message')
        end

        it 'appends an ErrorReport for the exception' do
          expect {subject.run!}.to change(subject.result.errors, :count).by(1)
        end
      end

      it 'reports the results' do
        expect(subject).to receive(:report_results)
        subject.run!
      end
    end
  end
end
