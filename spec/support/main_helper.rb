module MainHelper

  def prepare_file(file_path, content_type)
    content = send content_type
    file_dir = File.dirname file_path
    mkdir_p file_dir
    File.open(file_path, 'w+') { |file| file.write content }
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

  def helper
    <<FILE
module FirstHelper
  def i_am_logged_as_admin
    sign_in admin
  end
end
FILE
  end

  def initializer
    <<FILE
RspecSteps.setup do |config|
  config.method_prefixes = %w[given_ when_ then_ and_]
  config.step_prefixes = %w[Given When Then And]
  config.rspec_steps_dir = 'spec/rspec_steps'
  config.method_dirs = %w(spec/rspec_steps spec/support)
  config.step_dirs = %w(spec/rspec_steps spec/steps)
  config.comment_specs_with_method_location = true
end
FILE
  end

  def rails_helper
    <<FILE
    
# Checks for pending migrations and applies them before tests are run.

FILE
  end
end
