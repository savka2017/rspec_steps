require 'string_helper'

module RspecSteps
  module Generators
    module MainHelper
      include StringHelper
      # strip all spaces, comments, prefixes, empty brackets, and replace real args with generic arg1,arg2..,argN
      def build_generic_method(line)
        method = method_from_line line
        method = build_method to_name_and_args(depoet(method)) if has_args?(method)
        method
      end

      # strip prefixes, comments, and empty brackets
      def method_from_line(line)
        strip_prefixes(decomment(line).strip)&.gsub('()', '')
      end

      def strip_prefixes(line)
        prefixes = ['def '] + RspecSteps.prefixes
        deprefix(line, prefixes)
      end

      # concat method name with generic args
      def build_method(method)
        method[0] + '(' + ('arg1'.."arg#{args_count dequote(method[1])}").to_a.join(',') + ')'
      end

      def args_count(args)
        args.split(',').count
      end

      def methods_from_file(file)
        lines = []
        File.read(file).each_line { |line| lines << build_generic_method(line) }
        lines.compact.uniq.map { |line| [line, file] }
      end

      def methods_from_dir(dir)
        lines = []
        searth_dir = File.join(dir, '**', '*_helper.rb')
        Dir[searth_dir].each { |file| lines << methods_from_file(file) }
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

      # comment(if file) or uncomment(if file == nil) line
      def comment_line(commented_file, line, file = nil)
        comment = file ? " # #{file.split('/')[1..-1].join('/')}\n" : "\n"
        gsub_file commented_file, line, decomment(line) + comment, {verbose: false }
      end

      def build_method_definitions(methods)
        methods.inject('') { |result, method| result << "\n\n  def #{method}\n  end" }
      end
    end
  end
end
