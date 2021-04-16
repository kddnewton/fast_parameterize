# frozen_string_literal: true

require 'fast_parameterize/version'
require 'fast_parameterize/fast_parameterize'

# By default, FastParameterize already defines String#parameterize and
# FastParameterize::parameterize. In the case that we're using ActiveSupport,
# however, there is the additional functionality of transliteration that we need
# to account for. In this case, we're going to first allow ActiveSupport to do
# that work, then we're going to do the actual parameterization.
module FastParameterize
  # Override ActiveSupport::Inflector::parameterize to use
  # FastParameterize::parameterize.
  module ActiveSupportInflectorPatch
    def parameterize(string, separator: '-', preserve_case: false, locale: nil)
      FastParameterize.parameterize(
        ActiveSupport::Inflector.transliterate(string, locale: locale),
        separator: separator,
        preserve_case: preserve_case
      )
    end
  end

  # Override String#parameterize to use FastParameterize::parameterize.
  module ActiveSupportStringPatch
    def parameterize(separator: '-', preserve_case: false, locale: nil)
      FastParameterize.parameterize(
        ActiveSupport::Inflector.transliterate(self, locale: locale),
        separator: separator,
        preserve_case: preserve_case
      )
    end
  end

  # Override ActiveSupport::Inflector::method_added so that if and when the
  # parameterize method gets defined, we can immediately redefine it.
  module ActiveSupportDelayedPatch
    def method_added(method)
      FastParameterize.active_support if method == :parameterize
      super
    end
  end

  # Hook into ActiveSupport::Inflector and String to take advantage of
  # FastParameterize.
  def self.active_support
    ActiveSupport::Inflector.alias_method(:as_parameterize, :parameterize)
    ActiveSupport::Inflector.extend(ActiveSupportInflectorPatch)
    String.include(ActiveSupportStringPatch)
  end
end

if defined?(ActiveSupport)
  FastParameterize.active_support
else
  module ActiveSupport
    module Inflector
      prepend(FastParameterize::ActiveSupportDelayedPatch)
    end
  end
end
