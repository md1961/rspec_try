# coding: utf-8

require_relative 'stack'


describe Stack do

  let(:stack) { Stack.new }

  describe '#push' do
    context '正常値' do
      it '返り値はpushした値であること' do
        expect(stack.push('value')).to eq 'value'
      end
    end

    context 'nilをpushした場合' do
      it '例外を投げること' do
        expect { stack.push(nil) }.to raise_error ArgumentError
      end
    end
  end

  describe '#pop' do
    subject { stack.pop }

    context 'スタックが空の場合' do
      it { is_expected.to be_nil }
    end

    context 'スタックに値がある場合' do
      before do
        stack.push 'first value'
        stack.push 'second value'
        stack.push 'last value'
      end

      it { is_expected.to eq 'last value' }
    end
  end

  describe '#size' do
    it 'スタックのサイズを返すこと' do
      expect(stack.size).to eq 0

      stack.push 'value1'
      expect(stack.size).to eq 1

      stack.push 'value2'
      expect(stack.size).to eq 2
    end
  end
end
