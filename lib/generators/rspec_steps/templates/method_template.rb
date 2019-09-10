module MethodTemplate
  extend RspecSteps::Aliaseble
end

RSpec.configure do |config|
  config.include MethodTemplate
end

MethodTemplate.build_aliases
