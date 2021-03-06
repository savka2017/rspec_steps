require 'rails/generators'
require_relative 'main_helper'

module RspecSteps
  module Generators
    class RspecStepsGenerator < Rails::Generators::NamedBase
      include RspecSteps::Generators::MainHelper

      source_root File.expand_path("../templates", __FILE__)

      namespace 'rspec_steps'
      desc "Generates/updates helper file with definitions of method(s)/step(s)\
            that(s) has been found in spec/feature file"

      attr_accessor :existing_defs, :new_defs, :mode, :root_path, :method_defs

      def create_methods
        set_mode
        if collect_methods.empty?
          puts 'All methods/steps from this file already defined'
        else
          build_defs_container
          puts "Create #{new_defs_count} definition(s)"
        end
        if comment_methods? && mode_method?
          comments_count = comment_spec
          puts "Add #{comments_count} comments to #{file_path}" unless comments_count == 0
        end
      end

      private

      def set_mode
        @mode = File.extname(file_path) == '.feature' ? 'step' : 'method'
        @root_path = Rails.root.to_s + '/'
      end

      def collect_methods
        @existing_defs = existing_definitions
        current_defs = defs_from_file file_path
        method_definitions if mode_step?
        @new_defs = current_defs.map(&:first) - existing_defs.map(&:first)
      end

      def existing_definitions
        definition_dirs.inject([]) { |m, dir| m << defs_from_dir(Rails.root.join(dir)) }.flatten(1).compact
      end

      def method_definitions
        @mode = 'method'
        @method_defs = existing_definitions.map(&:first)
        @mode = 'step'
      end

      def build_defs_container
        relative_path = File.dirname(file_path.delete_prefix root_path).split('/')[1..-1].join('/')
        container_name = "#{file_name.gsub('_spec.rb', '_helper')}" if mode_method?
        container_name = "#{file_name.gsub('.feature', '')}" if mode_step?
        container_path = File.join(rspec_steps_dir, relative_path, container_name) + '.rb'

        unless File.exist?(container_path)
          template "#{mode}_template.rb", container_path
          gsub_file container_path, 'MethodTemplate', container_name.camelize if mode_method?
        end

        methods_anchor = 'extend RspecSteps::Aliaseble'
        defs = build_definitions new_defs
        insert_into_file(container_path,defs, after: methods_anchor) if mode_method?
        append_to_file(container_path, defs) if mode_step?
      end

      def comment_spec
        comment_file(file_path, existing_defs)
      end

      def comment_file(file, methods)
        comments_count = 0
        File.read(file).each_line do |line|
          generic_method = build_generic_method line
          if generic_method
            method = methods.detect { |e| e.first == generic_method }
            comment_line(file, line, method&.second)
            comments_count += 1 if method
          end
        end
        comments_count
      end

      def comment_line(commented_file, line, file = nil)
        file&.delete_prefix! root_path
        comment = file ? " # #{file.split('/')[1..-1].join('/')}\n" : "\n"
        gsub_file commented_file, line, decomment(line) + comment, {verbose: false }
      end

      def defs_from_file(file)
        lines = []
        File.read(file).each_line { |line| lines << send("build_generic_#{@mode}", line) }
        lines.compact.uniq.map { |line| [line, file] }
      end

      def defs_from_dir(dir)
        lines = []
        searth_dir = File.join(dir, '**', '*.rb')
        Dir[searth_dir].each { |file| lines << defs_from_file(file) }
        lines.flatten(1).uniq(&:first)
      end

      def build_definitions(defs)
        defs.inject('') { |result, d| result << defs_pattern(d) }
      end

      def defs_pattern(defs)
        mode_step? ? "step '#{defs}' do\n#{one_step(defs)}\nend\n\n" : "\n\n  def #{defs}\n  end"
      end

      def one_step(step)
        method = step.downcase.gsub(' ', '_')
        method_defs.include?(method) ? "  #{method}" : ''
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

      def mode_method?
        mode == 'method'
      end

      def mode_step?
        mode == 'step'
      end
    end
  end
end
