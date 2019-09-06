module TemplateHelper
  extend RspecSteps::Aliaseble
end

RSpec.configure do |config|
  config.include TemplateHelper
end

TemplateHelper.build_aliases
