require 'rails/generators/named_base'
require_relative 'main_helper'

module RspecSteps
  module Generators
    class RspecStepsGenerator < Rails::Generators::NamedBase
      include RspecSteps::Generators::MainHelper

      namespace "rspec_steps"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates/updates helper file with new methods definitions\
            that has been found in spec file"

      attr_accessor :spec_methods, :helpers_methods, :new_methods, :helper, :helper_path

      def create_methods
        extract_methods
        if new_methods.empty?
          puts 'All methods from this spec already defined'
        else
          build_helper
        end
        update_spec if comment_methods?
      end

      private

      def extract_methods
        @helpers_methods = extract_methods_from_dir RspecSteps.helpers_dir
        @spec_methods = extract_methods_from_file file_path
        @new_methods = spec_methods.map(&:first) - helpers_methods.map(&:first)
      end

      def build_helper
        relative_path = File.dirname(file_path).split('/')[2..-1].join('/') + '/'
        helper_name = "#{file_name.gsub('_spec.rb', '_helper')}"
        @helper_path = File.join(RspecSteps.helpers_dir, relative_path) + helper_name + '.rb'
        @helper = helper_name.titleize.gsub(' ', '')

        unless File.exist?(helper_path)
          template 'template_helper.rb', helper_path
          gsub_file helper_path, 'TemplateHelper', helper
        end

        metods_anchor = 'extend RspecSteps::Aliaseble'
        methods = ''
        new_methods.each do |method|
          methods << "\n"
          methods << "\n  def #{method}"
          methods << "\n  end"
        end
        insert_into_file(helper_path, methods, after: metods_anchor)
      end

      def update_spec
        comment_file(file_path)
      end

      def comment_methods?
        RspecSteps.comment_specs_with_method_location
      end
    end
  end
end
