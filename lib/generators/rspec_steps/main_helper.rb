require 'string_helper'

module RspecSteps
  module Generators
    module MainHelper
      include StringHelper

      def build_generic_method(line)
        method = method_from_line line
        method = build_method to_name_and_args(depoet(method)) if has_args?(method)
        method
      end

      def build_generic_step(line)
        step_from_line(line.strip)
      end

      def method_from_line(line)
        strip_prefixes(decomment(line).strip)&.delete_suffix('()')
      end

      def step_from_line(line)
        new_line = strip_prefixes(decomment line)&.strip&.delete_suffix(' do')
        new_line&.gsub!(/\A'|'\Z/, '')
        new_line&.gsub!(/\A"|"\Z/, '')
        new_line
      end

      def strip_prefixes(line)
        pref = @mode == 'method' ? 'def ' : 'step '
        prefixes = [pref] + RspecSteps.send("#{@mode}_prefixes")
        deprefix(line, prefixes)
      end

      def build_method(method)
        method[0] + '(' + ('arg1'.."arg#{args_count dequote(method[1])}").to_a.join(',') + ')'
      end

      def args_count(args)
        args.split(',').count
      end

      def defs_from_file(file)
        lines = []
        File.read(file).each_line { |line| lines << send("build_generic_#{@mode}", line) }
        lines.compact.uniq.map { |line| [line, file] }
      end

      def defs_from_dir(dir)
        lines = []
        searth_dir = File.join(@root_path + dir, '**', '*.rb')
        Dir[searth_dir].each { |file| lines << defs_from_file(file) }
        lines.flatten(1).uniq(&:first)
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
        file&.delete_prefix! @root_path
        comment = file ? " # #{file.split('/')[1..-1].join('/')}\n" : "\n"
        gsub_file commented_file, line, decomment(line) + comment, {verbose: false }
      end

      def build_definitions(defs)
        defs.inject('') { |result, d| result << defs_pattern(d) }
      end

      def defs_pattern(defs)
        @mode == 'step' ? "step '#{defs}' do\nend\n\n" : "\n\n  def #{defs}\n  end"
      end
    end
  end
end
