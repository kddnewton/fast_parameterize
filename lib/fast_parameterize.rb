# frozen_string_literal: true

require 'fast_parameterize/version'
require 'fast_parameterize/fast_parameterize'

module FastParameterize
  def self.install
    ActiveSupport::Inflector.singleton_class.then do |clazz|
      clazz.alias_method(:as_parameterize, :parameterize)
      clazz.prepend(FastParameterize)
    end
  end
end

if defined?(ActiveSupport)
  FastParameterize.install
else
  module ActiveSupport
    module Inflector
      class << self
        prepend(
          Module.new do
            # Hooks into ActiveSupport::Inflector and waits for the
            # #parameterize method to be defined. When it is, it automatically
            # redefines it. Using this `prepend` trick to attempt to be a good
            # citizen in the case that someone else has already hooked into
            # `method_added` on `Inflector`.
            def method_added(method)
              FastParameterize.install if method == :parameterize
              super
            end
          end
        )
      end
    end
  end
end
