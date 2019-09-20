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
    line = 'RspecSteps.setup do |config|'
    expect(file_contain_line?(initializer_path, line)).to be_truthy
  end

  it 'places in rails_helper configuration code' do
    line = "Dir[Rails.root.join('spec/rspec_steps', '**', '*.rb')].each { |f| require f }"
    expect(file_contain_line?(helper_path, line)).to be_truthy
  end
end
