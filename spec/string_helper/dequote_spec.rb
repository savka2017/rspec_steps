require 'string_helper'

RSpec.describe '.dequote' do
  include StringHelper

  it 'convert single-quoted expression to one argument' do
    args = "arg1, 'some expression'"
    expect(dequote args).to eq 'arg1, arg'
  end

  it 'convert double-quoted expression to one argument' do
    args = '"some expression", arg2'
    expect(dequote args).to eq 'arg, arg2'
  end

  it 'success with mix-quoted expressions' do
    args = '"some expression", arg2, \'another expression\''
    expect(dequote args).to eq 'arg, arg2, arg'
  end

  it 'ignores comma inside quoted expression' do
    args = '"some, expression", arg2, \'another, expression\''
    expect(dequote args).to eq 'arg, arg2, arg'
  end
end
