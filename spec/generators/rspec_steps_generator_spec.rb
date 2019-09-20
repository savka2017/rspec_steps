require 'rspec_steps_generator'

RSpec.describe RspecSteps::Generators::RspecStepsGenerator, type: :generator do
  let(:generator) { RspecSteps::Generators::RspecStepsGenerator }
  let(:dummy_app_root) { File.expand_path('../dummy', __dir__) }

  let(:spec_path) { dummy_app_root + '/spec/features/admin/order_spec.rb' }
  let(:featere_path) { dummy_app_root + '/spec/acceptance/admin/order.feature' }
  let(:initializer_path) { dummy_app_root + '/config/initializers/rspec_steps.rb' }

  let(:run_generator_for_spec) { generator.start([spec_path], destination_root: dummy_app_root) }
  let(:run_generator_for_feature) { generator.start([featere_path], destination_root: dummy_app_root) }

  let(:spec_helper_path) { dummy_app_root + '/spec/rspec_steps/features/admin/order_helper.rb' }
  let(:feature_helper_path) { dummy_app_root + '/spec/rspec_steps/acceptance/admin/order.rb' }

  after do
    prepare_file initializer_path, :initializer, true
    FileUtils.rm_rf dummy_app_root + '/spec/rspec_steps'
  end

  describe 'mode - methdod' do
    before do
      prepare_file initializer_path, :initializer, false
      run_generator_for_spec
    end

    it 'creates feature dir within rspec_steps dir' do
      expect(File.exist? dummy_app_root + '/spec/rspec_steps/features').to be_truthy
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
      prepare_file initializer_path, :initializer, false
      run_generator_for_feature
    end

    it 'creates steps dir within rspec_steps dir' do
      expect(File.exist? dummy_app_root + '/spec/rspec_steps/acceptance').to be_truthy
    end

    it 'store relative feature path' do
      expect(File.exist? feature_helper_path).to be_truthy
    end

    it 'creates new steps definitions' do
      line = "step 'I visit order page' do"
      expect(file_contain_line?(feature_helper_path, line)).to be_truthy
    end

    it 'do not creates already defined methods' do
      line = "step 'I am logged in as Admin' do"
      expect(file_contain_line?(feature_helper_path, line)).to be_falsey
    end
  end

  describe 'spec - comments' do
    before do
      run_generator_for_spec
    end

    after do
      prepare_file spec_path, :spec
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
