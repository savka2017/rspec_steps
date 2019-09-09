require 'rails/generators'

module RspecSteps
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates RspecSteps initializer and configure your application.'

      def copy_initializer
        template 'rspec_steps.rb', 'config/initializers/rspec_steps.rb'
      end

      def configure_rails_helper
        insert_into_file 'spec/rails_helper.rb', rails_helper_require, before: rails_helper_anchor
      end

      private

      def rails_helper_require
        "Dir[Rails.root.join('#{RspecSteps.rspec_steps_dir}', '**', '*.rb')].each { |f| require f }\n"
      end

      def rails_helper_anchor
        "\n# Checks for pending migrations and applies them before tests are run."
      end
    end
  end
end
