require_relative '../../lib/generators/rspec_steps/main_helper'

RSpec.describe '.build_generic_method' do
  include RspecSteps::Generators::MainHelper

  it 'remove comment from line' do
    line = 'def my_method # some comment'
    expect(build_generic_method(line)).to eq 'my_method'
  end

  it 'ignores all lines that do not start with def or prefixes' do
    line = 'my_method'
    expect(build_generic_method(line)).to eq nil
  end

  it 'recognizes lines starting with def' do
    line = 'def my_method'
    expect(build_generic_method(line)).to eq 'my_method'
  end

  it 'recognizes lines starting with prefixes' do
    line = 'i_am_logged_as_admin'
    RspecSteps.prefixes.each do |prefix|
      expect(build_generic_method("#{prefix}#{line}")).to eq 'i_am_logged_as_admin'
    end
  end

  it 'recognizes one argument in method' do
    line = 'given_i_am_logged_as(admin)'
    expect(build_generic_method(line)).to eq 'i_am_logged_as(arg1)'
  end

  it 'recognizes several arguments in method' do
    line = 'given_table_contains_value(table, value)'
    expect(build_generic_method(line)).to eq 'table_contains_value(arg1,arg2)'
  end

  it 'ignores commas inside single-quoted arguments' do
    line = "given_table_contains_value(argument, 'Argument, with comma', 'Argument, that also contain comma')"
    expect(build_generic_method(line)).to eq 'table_contains_value(arg1,arg2,arg3)'
  end

  it 'ignores commas inside double-quoted arguments' do
    line = 'given_table_contains_value(argument, "Argument, with comma", "Argument, that also contain comma")'
    expect(build_generic_method(line)).to eq 'table_contains_value(arg1,arg2,arg3)'
  end

  it 'ignores commas inside single- and double-quoted arguments' do
    line = 'given_table_contains_value(argument, \'Argument, with comma\', "Argument, that also contain comma")'
    expect(build_generic_method(line)).to eq 'table_contains_value(arg1,arg2,arg3)'
  end

  it 'strips empty () from the end of the method' do
    line = 'when_i_confirm_dialog()'
    expect(build_generic_method(line)).to eq 'i_confirm_dialog'
  end
end
