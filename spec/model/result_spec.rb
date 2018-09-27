require 'spec_helper'

require 'model/customer'
require 'model/result'

describe Result do
  describe 'a new instance' do
    context 'given no arguments' do
      it 'has an empty customers_to_invite array' do
        expect(subject.customers_to_invite).to eq([])
      end
      it 'has an empty errors array' do
        expect(subject.errors).to eq([])
      end
    end
  end

  describe '#sorted_customers' do
    context 'when there are customers_to_invite' do
      let(:customer_1) { Customer.new(user_id: 1, name: "Zakk Zippy") }
      let(:customer_2) { Customer.new(user_id: 2, name: "Alvin Armstrong") }

      before do
        # add them in reverse order, to test the sorting
        subject.customers_to_invite << customer_2
        subject.customers_to_invite << customer_1
      end

      it 'returns the customers sorted by ascending user_id' do
        expect(subject.sorted_customers).to eq([
          customer_1, customer_2
        ])
      end
    end
    context 'when there are no customers_to_invite' do
      it 'returns an empty array' do
        expect(subject.sorted_customers).to eq([])
      end
    end
  end
end
