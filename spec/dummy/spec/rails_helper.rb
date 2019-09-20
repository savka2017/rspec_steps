    Dir[Rails.root.join('spec/rspec_steps', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.

