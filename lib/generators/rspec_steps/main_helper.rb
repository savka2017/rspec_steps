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
    end
  end
end
