RspecSteps.setup do |config|
  config.method_prefixes = %w[given_ when_ then_ and_]
  config.step_prefixes = %w[Given When Then And]
  config.rspec_steps_dir = 'spec/rspec_steps'
  config.method_dirs = %w(spec/rspec_steps spec/support)
  config.step_dirs = %w(spec/rspec_steps spec/steps)
  config.comment_specs_with_method_location = false
end
