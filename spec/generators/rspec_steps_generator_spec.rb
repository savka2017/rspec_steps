require 'rspec_steps_generator'
require 'rspec_steps'

RSpec.describe RspecSteps::Generators::RspecStepsGenerator do
  include RspecSteps
  let(:generator) { RspecSteps::Generators::RspecStepsGenerator }
  let(:dummy_app_root) { File.expand_path('../dummy', __dir__) }

  let(:spec_path) { File.join(dummy_app_root, 'spec', 'features', 'admin', 'order_spec.rb') }
  let(:featere_path) { File.join(dummy_app_root, 'spec', 'acceptance', 'admin', 'order.feature') }

  let(:run_generator_for_spec) { generator.start([spec_path], destination_root: dummy_app_root) }
  let(:run_generator_for_feature) { generator.start([featere_path], destination_root: dummy_app_root) }

  let(:spec_helper_path) { File.join(dummy_app_root, 'spec', 'rspec_steps', 'features', 'admin', 'order_helper.rb') }
  let(:feature_helper_path) { File.join(dummy_app_root, 'spec', 'rspec_steps', 'acceptance', 'admin', 'order.rb') }

  after do
    FileUtils.rm_rf dummy_app_root + '/spec/rspec_steps'
    FileUtils.rm_rf dummy_app_root + '/spec/features'
  end

  describe 'mode - methdod' do
    before do
      prepare_file spec_path, :spec
      switch_comments_to false
      run_generator_for_spec
    end

    it 'creates feature dir within rspec_steps dir' do
      expect(File.exist? File.join(dummy_app_root, 'spec', 'rspec_steps', 'features')).to be_truthy
    end

    it 'store relative spec path' do
      expect(File.exist? spec_helper_path).to be_truthy
    end

    it 'creates new methods definitions' do
      line = 'def i_visit_orders_page'
      expect(file_contain_line?(spec_helper_path, line)).to be_truthy
    end

    it 'do not creates already defined methods' do
      line = 'def i_am_logged_as_admin'
      expect(file_contain_line?(spec_helper_path, line)).to be_falsey
    end
  end

  describe 'mode - step' do
    before do
      switch_comments_to false
      run_generator_for_feature
    end

    it 'creates steps dir within rspec_steps dir' do
      expect(File.exist? File.join(dummy_app_root, 'spec', 'rspec_steps', 'acceptance')).to be_truthy
    end

    it 'store relative .feature path' do
      expect(File.exist? feature_helper_path).to be_truthy
    end

    it 'creates new steps definitions' do
      line = "step 'I visit order page' do"
      expect(file_contain_line?(feature_helper_path, line)).to be_truthy
    end

    it 'do not creates already defined steps' do
      line = "step 'I am logged in as Admin' do"
      expect(file_contain_line?(feature_helper_path, line)).to be_falsey
    end
  end

  describe 'spec - comments' do
    before do
      prepare_file spec_path, :spec
      switch_comments_to true
      run_generator_for_spec
    end

    it 'add comments to already defined methods' do
      line = 'given_i_am_logged_as_admin # support/first_helper.rb'
      expect(file_contain_line?(spec_path, line)).to be_truthy
    end

    it 'do not add comments to new methods' do
      line_with_comment = 'when_i_visit_orders_page #'
      line_without_comment = 'when_i_visit_orders_page'
      expect(file_contain_line?(spec_path, line_with_comment)).to be_falsey
      expect(file_contain_line?(spec_path, line_without_comment)).to be_truthy
    end
  end
end
