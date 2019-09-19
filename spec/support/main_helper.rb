module MainHelper
  def prepare_file(file_path, content)
    file_dir = File.dirname file_path
    mkdir_p file_dir
    File.open(file_path, 'w+') { |file| file.write content }
  end
end
