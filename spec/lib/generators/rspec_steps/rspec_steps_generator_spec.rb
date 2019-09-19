require 'generator_spec'
require 'rspec_steps_generator'

RSpec.describe RspecSteps::Generators::RspecStepsGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)
  arguments %W(/home/andriy/MyProjects/rspec_steps/spec/lib/generators/tmp/spec/features/admin/order_spec.rb)

  before(:all) do
    prepare_destination

    prepare_file destination_root + '/spec/features/admin/order_spec.rb', :spec
    prepare_file destination_root + '/spec/support/first_helper.rb', :helper
    prepare_file destination_root + '/config/initializers/rspec_steps.rb', :initializer

    run_generator
  end

  specify do
    expect(destination_root).to have_structure {
      directory 'spec' do
        directory 'rspec_steps' do
          directory 'features' do
            directory 'admin' do
              file 'order_helper.rb' do
                contains 'def i_visit_orders_page'
              end
            end
          end
        end
      end
    }
  end
end
