RspecSteps.setup do |config|
  config.prefixes = %w[given_ when_ then_ and_]
  config.helpers_dir = 'spec/rspec_steps'
  config.comment_specs_with_method_location = true
end