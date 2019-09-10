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

      attr_accessor :existing_defs, :new_defs, :mode

      def create_methods
        set_mode
        if collect_methods.empty?
          puts 'All methods from this spec already defined'
        else
          build_defs_container
          puts "Create #{new_defs_count} definition(s)"
        end
        p new_defs
        if comment_methods? && mode == 'method'
          comments_count = comment_spec
          puts "Add #{comments_count} comments to #{file_path}" unless comments_count == 0
        end
      end

      private

      def set_mode
        @mode = File.extname(file_path) == '.feature' ? 'step' : 'method'
      end

      def collect_methods
        @existing_defs = definition_dirs.inject([]) { |m, dir| m << defs_from_dir(dir) }.flatten(1).compact
        p existing_defs
        current_defs = defs_from_file file_path
        p current_defs
        @new_defs = current_defs.map(&:first) - existing_defs.map(&:first)
      end

      def build_defs_container
        relative_path = File.dirname(file_path).split('/')[2..-1].join('/')
        container_name = "#{file_name.gsub('_spec.rb', '_helper')}" if mode == 'method'
        container_name = "#{file_name.gsub('.feature', '')}" if mode == 'step'
        container_path = File.join(rspec_steps_dir, relative_path, container_name) + '.rb'

        unless File.exist?(container_path)
          template "#{mode}_template.rb", container_path
          gsub_file container_path, 'MethodTemplate', container_name.camelize
        end

        methods_anchor = 'extend RspecSteps::Aliaseble'
        defs = send("build_definitions", new_defs)
        insert_into_file(container_path,defs, after: methods_anchor) if mode == 'method'
        append_to_file(container_path, defs) if mode == 'step'
      end

      def comment_spec
        comment_file(file_path, existing_defs)
      end

      def new_defs_count
        new_defs.count
      end

      def comment_methods?
        RspecSteps.comment_specs_with_method_location
      end

      def definition_dirs
        RspecSteps.send "#{mode}_dirs"
      end

      def rspec_steps_dir
        RspecSteps.rspec_steps_dir
      end
    end
  end
end
