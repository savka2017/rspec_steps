require 'string_helper'

RSpec.describe '.has_args?' do
  include StringHelper

  it 'return nil when arguments are absent' do
    method = 'some_method'
    expect(has_args?(method)).to be_falsey
  end

  it 'return true if present argument in brackets' do
    method = 'some_method(some_arg)'
    expect(has_args?(method)).to be_truthy
  end

  it 'return true if present argument without brackets' do
    method = 'some_method some_arg'
    expect(has_args?(method)).to be_truthy
  end
end
