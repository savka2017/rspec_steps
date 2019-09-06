module RspecSteps
  module Generators
    module MainHelper
      def extract_method_from_line(line)
        result = strip_prefixes(strip_comment(line).strip)
        if result
          params = extract_params result
          method = extract_method result, params
          result = build_method(method, params.count(',') + 1) unless result == method
        end
        result
      end

      def strip_comment(line)
        line.gsub(/\S*#.*$/, '').rstrip
      end

      def strip_prefixes(line)
        prefixes = ['def '] + RspecSteps.prefixes
        prefixes.each { |prefix| return line.gsub(prefix, '') if line.start_with? prefix }
        nil
      end

      def build_method(method, params_count)
        method + '(' + ('param1'.."param#{params_count}").to_a.join(',') + ')'
      end

      def extract_params(line)
        line.scan(/\((.*)\)/).flatten[0].to_s
      end

      def extract_method(line, params)
        line.gsub(params, '').delete_suffix('()')
      end

      def extract_methods_from_file(file)
        file_lines = File.read file
        lines = []
        file_lines.each_line { |line| lines << extract_method_from_line(line) }
        lines.compact!.uniq!
        lines.map { |line| [line, file] }
      end

      def extract_methods_from_dir(dir)
        lines = []
        searth_dir = File.join(dir, '**', '*_helper.rb')
        Dir[searth_dir].each do |file|
          extract_methods_from_file(file).each { |method| lines << method }
        end
        lines.uniq(&:first)
      end

      def comment_file(commented_file)
        temp_file = Tempfile.new 'spec'
        begin
          File.open(commented_file, 'r') do |file|
            until file.eof?
              new_line = file.readline
              method = extract_method_from_line(new_line)
              if method
                helpers_methods.each do |helper_method|
                  new_line = comment_line(new_line, helper_method.second) if helper_method.first == method
                end
              end
              temp_file.puts new_line
            end
          end
          temp_file.close
          FileUtils.mv(temp_file.path, file_path)
        ensure
          temp_file.close
          temp_file.unlink
        end
      end

      def comment_line(line, file)
        method = line.gsub(/\S*#.*$/, '').strip
        line_with_comments = line.strip
        line.gsub(line_with_comments, method + " # #{file.gsub(RspecSteps.helpers_dir, '')}")
      end
    end
  end
end
