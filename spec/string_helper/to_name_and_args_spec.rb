require 'string_helper'

RSpec.describe '.to_name_and_args' do
  include StringHelper

  it 'devide method into method-name and method-args' do
    method = 'some_method(some_args)'
    method = to_name_and_args(method)
    expect(method[0]).to eq 'some_method'
    expect(method[1]).to eq 'some_args'
  end

  it 'success when method has several arguments' do
    method = 'some_method(arg1, arg2, arg3)'
    method = to_name_and_args(method)
    expect(method[0]).to eq 'some_method'
    expect(method[1]).to eq 'arg1, arg2, arg3'
  end
end
