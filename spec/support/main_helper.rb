module MainHelper
  def prepare_file(file_path, content_type)
    template_path = send content_type
    FileUtils.mkdir_p File.dirname file_path
    FileUtils.cp template_path, file_path
  end

  def file_contain_line?(file, line)
    result = false
    File.read(file).each_line do |file_line|
      result = true if file_line.include? line
    end
    result
  end

  def rails_helper
    Rails.root.join('spec', 'fixtures', 'rails_helper.rb')
  end

  def spec
    Rails.root.join('spec', 'fixtures', 'order_spec.rb')
  end
end
