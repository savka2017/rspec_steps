require 'install_generator'

RSpec.describe RspecSteps::Generators::InstallGenerator do
  let(:generator) { RspecSteps::Generators::InstallGenerator }
  let(:dummy_app_root) { File.expand_path('../dummy', __dir__) }
  let(:initializer_path) { dummy_app_root + '/config/initializers/rspec_steps.rb' }
  let(:helper_path) { dummy_app_root + '/spec/rails_helper.rb' }

  before do
    FileUtils.rm_rf initializer_path
    FileUtils.rm_rf helper_path

    prepare_file helper_path, :rails_helper
    generator.start([], destination_root: dummy_app_root)
  end

  it 'creates initializer' do
    expect(File.exist? dummy_app_root + '/config/initializers/rspec_steps.rb').to be_truthy
  end

  it 'places in initializer configuration code' do
    result = false
    File.read(initializer_path).each_line do |line|
      result = true if line.include? 'RspecSteps.setup do |config|'
    end
    expect(result).to be_truthy
  end

  it 'places in rails_helper configuration code' do
    result = false
    File.read(helper_path).each_line do |line|
      result = true if line.include? "Dir[Rails.root.join('spec/rspec_steps', '**', '*.rb')].each { |f| require f }"
    end
    expect(result).to be_truthy
  end
end
