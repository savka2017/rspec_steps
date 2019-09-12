require 'main_helper'

RSpec.describe '.build_generic_step' do
  include RspecSteps::Generators::MainHelper

  before do
    @mode = 'step'
  end

  it 'remove comment from step definition' do
    line = "step 'I am logged as admin' do # some comment"
    expect(build_generic_step(line)).to eq 'I am logged as admin'
  end

  it 'remove comment from .feature line' do
    line = "Given I am logged as admin # some comment"
    expect(build_generic_step(line)).to eq 'I am logged as admin'
  end

  it 'ignores all lines that do not start with step or prefixes' do
    line = 'my_method'
    expect(build_generic_step(line)).to eq nil
  end

  it 'recognizes lines starting with step' do
    line = 'step "my_method" do'
    expect(build_generic_step(line)).to eq 'my_method'
  end

  it 'recognizes lines starting with prefixes' do
    line = 'I am logged as admin'
    RspecSteps.step_prefixes.each do |prefix|
      expect(build_generic_step("#{prefix} '#{line}'")).to eq 'I am logged as admin'
    end
  end

  it 'success with double-quoted steps' do
    line = 'step "I am logged as admin" do'
    expect(build_generic_step(line)).to eq 'I am logged as admin'
  end

  it 'success with single-quoted steps' do
    line = "step 'I am logged as admin' do"
    expect(build_generic_step(line)).to eq 'I am logged as admin'
  end

  it 'success with steps containing single-quoted text' do
    line =<<TEXT
      step "I click 'OK' button" do
TEXT
    expect(build_generic_step(line)).to eq 'I click \'OK\' button'
  end

  it 'success with steps containing double-quoted text' do
    line =<<TEXT
      step 'I click "OK" button' do
TEXT
    expect(build_generic_step(line)).to eq 'I click "OK" button'
  end
end
