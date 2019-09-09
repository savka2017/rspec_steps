# frozen_string_literal: true

require 'rspec_steps/version'
require 'active_support/dependencies'

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

  mattr_accessor :rspec_steps_dir
  self.rspec_steps_dir = 'spec/rspec_steps'

  mattr_accessor :helper_dirs
  self.helper_dirs = %w(spec/rspec_steps spec/support)

  mattr_accessor :prefixes
  self.prefixes = %w[given_ when_ then_ and_]

  mattr_accessor :comment_specs_with_method_location
  self.comment_specs_with_method_location = true

  def self.setup
    yield self
  end
end
