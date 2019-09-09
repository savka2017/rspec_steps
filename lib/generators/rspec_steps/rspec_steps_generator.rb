require 'rails/generators/named_base'
require_relative 'main_helper'

module RspecSteps
  module Generators
    class RspecStepsGenerator < Rails::Generators::NamedBase
      include RspecSteps::Generators::MainHelper

      namespace "rspec_steps"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates/updates helper file with definitions of method(s)\
            that(s) has been found in spec file"

      attr_accessor :defined_methods, :new_methods

      def create_methods
        if collect_methods.empty?
          puts 'All methods from this spec already defined'
        else
          build_helper
          puts "Create definition(s) for #{new_methods_count} method(s)"
        end
        if comment_methods?
          comments_count = comment_spec
          puts "Add #{comments_count} comments to #{file_path}" unless comments_count == 0
        end
      end

      private

      def collect_methods
        @defined_methods = helper_dirs.inject([]) { |m, dir| m << methods_from_dir(dir) }.flatten(1).compact
        spec_methods = methods_from_file file_path
        @new_methods = spec_methods.map(&:first) - defined_methods.map(&:first)
      end

      def build_helper
        relative_path = File.dirname(file_path).split('/')[2..-1].join('/')
        helper_name = "#{file_name.gsub('_spec.rb', '_helper')}"
        helper_path = File.join(rspec_steps_dir, relative_path, helper_name) + '.rb'

        unless File.exist?(helper_path)
          template 'template_helper.rb', helper_path
          gsub_file helper_path, 'TemplateHelper', helper_name.camelize
        end

        methods_anchor = 'extend RspecSteps::Aliaseble'
        methods = build_method_definitions(new_methods)
        insert_into_file(helper_path, methods, after: methods_anchor)
      end

      def comment_spec
        comment_file(file_path, defined_methods)
      end

      def new_methods_count
        new_methods.count
      end

      def comment_methods?
        RspecSteps.comment_specs_with_method_location
      end

      def helper_dirs
        RspecSteps.helper_dirs
      end

      def rspec_steps_dir
        RspecSteps.rspec_steps_dir
      end
    end
  end
end
