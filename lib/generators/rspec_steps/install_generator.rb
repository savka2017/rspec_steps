require 'rails/generators'

module RspecSteps
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates a RspecSteps initializer and configure your application.'

      def copy_initializer
        template 'rspec_steps.rb', 'config/initializers/rspec_steps.rb'
      end

      def configure_rails_helper
        insert_into_file(
          'spec/rails_helper.rb',
          "\nDir[Rails.root.join('spec', 'rspec_steps', '**', '*.rb')].each { |f| require f }",
          after: "# require only the support files necessary.\n"
        )
      end
    end
  end
end
