require 'generator_spec'
require 'install_generator'

RSpec.describe RspecSteps::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  after(:all) do
    rm_rf(Dir[File.expand_path("../../tmp", __FILE__)])
  end

  specify do
    expect(destination_root).to have_structure {
      no_file "rspec_steps.rb"
      directory "config" do
        directory "initializers" do
          file "rspec_steps.rb" do
            contains 'config.comment_specs_with_method_location = true'
          end
        end
      end
    }
  end
end
