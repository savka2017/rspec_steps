# frozen_string_literal: true

require "rspec_steps/version"

module RspecSteps
  class Error < StandardError; end

  module Aliaseble
    def build_aliases
      prefixes = RspecSteps.prefixes
      all_methods = instance_methods(false)
      all_methods.each do |method|
        prefixes.each { |prefix| alias_method "#{prefix}#{method}", method }
      end
    end
  end

  mattr_accessor :helpers_dir
  @@helpers_dir = 'spec/rspec_steps'

  mattr_accessor :prefixes
  @@prefixes = %w[given_ when_ then_ and_]

  mattr_accessor :comment_specs_with_method_location
  @@comment_specs_with_method_location = true

  def self.setup
    yield self
  end
end
