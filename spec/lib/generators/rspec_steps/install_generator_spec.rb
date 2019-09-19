require 'generator_spec'
require 'install_generator'

RSpec.describe RspecSteps::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    spec_dir = destination_root + '/spec'
    mkdir_p spec_dir
    File.open(spec_dir + '/rails_helper.rb', 'w+') do |file|
      file.write("\n# Checks for pending migrations and applies them before tests are run.")
    end
    run_generator
  end

  after(:all) do
    rm_rf(destination_root)
  end

  specify do
    expect(destination_root).to have_structure {
      directory 'config' do
        directory 'initializers' do
          file 'rspec_steps.rb' do
            contains 'config.comment_specs_with_method_location = true'
          end
        end
      end
      directory 'spec' do
        file 'rails_helper.rb' do
          contains  'Dir[Rails.root.join'
        end
      end
    }
  end
end
