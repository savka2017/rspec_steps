require_relative '../lib/generators/rspec_steps/main_helper'

RSpec.describe RspecSteps::Generators::MainHelper do
  include RspecSteps::Generators::MainHelper

  describe '.extract_method_from_line' do
    it 'remove comment from line' do
      line = 'def my_method # some comment'
      expect(extract_method_from_line(line)).to eq 'my_method'
    end

    it 'ignores all lines that do not start with def or prefixes' do
      line = 'my_method'
      expect(extract_method_from_line(line)).to eq nil
    end

    it 'recognises lines starting with def' do
      line = 'def my_method'
      expect(extract_method_from_line(line)).to eq 'my_method'
    end

    it 'recognises lines starting with prefixes' do
      line = 'i_am_logged_as_admin'
      RspecSteps.prefixes.each do |prefix|
        expect(extract_method_from_line("#{prefix}#{line}")).to eq 'i_am_logged_as_admin'
      end
    end

    it 'recognises one parameter in method' do
      line = 'given_i_am_logged_as(admin)'
      expect(extract_method_from_line(line)).to eq 'i_am_logged_as(param1)'
    end

    it 'recognises several parameters in method' do
      line = 'given_table_contains_value(table, value)'
      expect(extract_method_from_line(line)).to eq 'table_contains_value(param1,param2)'
    end
  end
end
