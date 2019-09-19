require 'generator_spec'
require 'install_generator'

RSpec.describe RspecSteps::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination

    rails_helper = destination_root + '/spec/rails_helper.rb'
    content = "\n# Checks for pending migrations and applies them before tests are run."
    prepare_file rails_helper, content

    run_generator
  end

  after(:all) do
    rm_rf destination_root
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
