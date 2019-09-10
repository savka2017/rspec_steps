require 'string_helper'

RSpec.describe '.decomment' do
  include StringHelper

  it 'strips trailing spaces from line' do
    line = 'some_method  '
    expect(decomment(line)).to eq 'some_method'
  end

  it 'strip comment at the end of line' do
    line = 'some_method # some comment '
    expect(decomment(line)).to eq 'some_method'
  end

  it 'store spaces at the begin of line' do
    line = '  some_method # some comment '
    expect(decomment(line)).to eq '  some_method'
  end
end
