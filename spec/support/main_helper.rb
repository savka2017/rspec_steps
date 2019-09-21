module MainHelper
  def prepare_file(file_path, content_type)
    content = send content_type
    file_dir = File.dirname file_path
    FileUtils.mkdir_p file_dir
    File.open(file_path, 'w+') { |file| file.write content }
  end

  def file_contain_line?(file, line)
    result = false
    File.read(file).each_line do |file_line|
      result = true if file_line.include? line
    end
    result
  end

  def rails_helper
    <<FILE
    
# Checks for pending migrations and applies them before tests are run.

FILE
  end

  def spec
    <<FILE
RSpec.describe 'Sample' do
  it 'allow admin to create new order' do
    given_i_am_logged_as_admin
    when_i_visit_orders_page
  end
end
FILE
  end
end
