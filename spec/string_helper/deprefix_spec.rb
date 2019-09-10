require 'string_helper'

RSpec.describe '.deprefix' do
  include StringHelper

  let(:prefixes) { ['when_', 'then_', 'def '] }

  it 'strips prefix from line' do
    line = 'def some_method'
    expect(deprefix(line, prefixes)).to eq 'some_method'
  end

  it 'return nil when any of prefixes are present' do
    line = 'some_method'
    expect(deprefix(line, prefixes)).to eq nil
  end

  it 'ignores prefixes inside line' do
    line = 'some_method_with_when_word'
    expect(deprefix(line, prefixes)).to eq nil
  end
end
