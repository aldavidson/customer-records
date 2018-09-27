require 'spec_helper'

require 'lib/result_formatter'

describe ResultFormatter do
  let(:customer_x) { Customer.new(name: 'customer x', user_id: 222) }
  let(:customer_y) { Customer.new(name: 'customer y', user_id: 111) }
  let(:error_1) do
    ErrorReport.new(
      line_number: 1,
      json: 'json 1',
      exception: double('exception', message: 'exception 1')
    )
  end
  let(:error_2) do
    ErrorReport.new(
      line_number: 2,
      json: 'json 2',
      exception: double('exception', message: 'exception 2')
    )
  end
  let(:result) do
    Result.new(
      customers_to_invite: [customer_y, customer_x],
      errors: [error_1, error_2]
    )
  end
  subject { described_class.new(result: result) }

  describe '#customers_to_invite' do
    before do
      allow(subject).to receive(:formatted_customer)
                        .with(customer_x)
                        .and_return('formatted customer x')
      allow(subject).to receive(:formatted_customer)
                        .with(customer_y)
                        .and_return('formatted customer y')
    end

    context 'given an argument which responds to <<' do
      let(:arg) { [] }

      it 'appends a formatted_customer for each sorted customer in the result' do
        subject.customers_to_invite(arg)
        expect(arg).to eq(["formatted customer y\n", "formatted customer x\n"])
      end
    end

    context 'given no argument' do
      it 'appends to STDOUT' do
        expect(STDOUT).to receive(:<<).with("formatted customer y\n")
        expect(STDOUT).to receive(:<<).with("formatted customer x\n")
        subject.customers_to_invite()
      end
    end

    describe '#errors' do
      before do
        allow(subject).to receive(:formatted_error)
                          .with(error_1)
                          .and_return('formatted error 1')
        allow(subject).to receive(:formatted_error)
                          .with(error_2)
                          .and_return('formatted error 2')
      end

      context 'given an argument which responds to <<' do
        let(:arg) { [] }

        it 'appends a formatted_error for each error in the result' do
          subject.errors(arg)
          expect(arg).to eq(["formatted error 1\n", "formatted error 2\n"])
        end
      end

      context 'given no argument' do
        it 'appends to STDERR' do
          expect(STDERR).to receive(:<<).with("formatted error 1\n")
          expect(STDERR).to receive(:<<).with("formatted error 2\n")
          subject.errors()
        end
      end
    end
  end

  describe '#formatted_customer' do
    it 'returns the given customers user_id & name joined with a comma' do
      expect(subject.send(:formatted_customer, customer_x)).to eq('222, customer x')
    end
  end

  describe '#formatted_error' do
    it 'returns a string' do
      expect(subject.send(:formatted_error, error_1)).to be_a(String)
    end

    describe 'the returned string' do
      let(:returned_string) { subject.send(:formatted_error, error_1) }

      it 'starts with "line (line_number): (exception message)"' do
        expect(returned_string).to start_with("line 1: exception 1")
      end

      it 'ends with (json: "<the json>")' do
        expect(returned_string).to end_with('(json: "json 1")')
      end
    end
  end
end
