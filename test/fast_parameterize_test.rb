# frozen_string_literal: true

require 'test_helper'

class FastParameterizeTest < Minitest::Test
  def test_version
    refute_nil ::FastParameterize::VERSION
  end
end
