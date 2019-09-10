require 'string_helper'

RSpec.describe '.depoet' do
  include StringHelper

  it 'return unchanged value if method is not in poetic style' do
    method = 'some_method(some_args)'
    expect(depoet(method)).to eq method
  end

  it 'return unchanged value for method without arguments' do
    method = 'some_method'
    expect(depoet(method)).to eq method
  end

  it 'return unchanged value for method with empty brackets' do
    method = 'some_method()'
    expect(depoet(method)).to eq method
  end

  it 'return unchanged value for method in classic style' do
    method = 'some_method(arg1, arg2)'
    expect(depoet(method)).to eq method
  end

  it 'convert poetic method to classic style' do
    method = 'some_method some_arg'
    expect(depoet(method)).to eq 'some_method(some_arg)'
  end

  it 'success with several arguments' do
    method = 'some_method arg1, arg2, arg3'
    expect(depoet(method)).to eq 'some_method(arg1, arg2, arg3)'
  end
end
