RspecSteps.setup do |config|
  config.prefixes = %w[given_ when_ then_ and_]
  config.rspec_steps_dir = 'spec/rspec_steps'
  config.helper_dirs = %w(spec/rspec_steps spec/support)
  config.comment_specs_with_method_location = true
end