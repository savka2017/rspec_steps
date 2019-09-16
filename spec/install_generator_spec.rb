require 'generator_spec'
require 'install_generator'

RSpec.describe RspecSteps::Generators::InstallGenerator, type: :generator do

  before(:all) do
    run_generator
  end

  it 'creates initializer' do
    expect(File.exist? 'config/initializers/rspec_steps.rb').to be_truthy
  end
end
