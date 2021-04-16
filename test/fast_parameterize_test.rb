# frozen_string_literal: true

require 'test_helper'

class FastParameterizeTest < Minitest::Test
  def test_basic
    assert_equal 'foo-bar-baz', '^FOO@BAR?BAZ$'.parameterize
  end

  def test_separator
    assert_equal 'foo_bar_baz', '^FOO@BAR?BAZ$'.parameterize(separator: '_')
    assert_equal 'foo..bar..baz', '^FOO@BAR?BAZ$'.parameterize(separator: '..')
  end

  def test_preserve_case
    assert_equal 'FOO-BAR-BAZ', '^FOO@BAR?BAZ$'.parameterize(preserve_case: true)
  end

  def test_version
    refute_nil ::FastParameterize::VERSION
  end
end
