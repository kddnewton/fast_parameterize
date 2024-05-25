# frozen_string_literal: true

require_relative "lib/fast_parameterize/version"

version = FastParameterize::VERSION
repository = "https://github.com/kddnewton/fast_parameterize"

Gem::Specification.new do |spec|
  spec.name = "fast_parameterize"
  spec.version = version
  spec.authors = ["Kevin Newton"]
  spec.email = ["kddnewton@gmail.com"]

  spec.summary = "Fast String#parameterize implementation"
  spec.description = "Provides a C-optimized method for parameterizing a string"
  spec.homepage = repository
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "#{repository}/issues",
    "changelog_uri" => "#{repository}/blob/v#{version}/CHANGELOG.md",
    "source_code_uri" => repository,
    "rubygems_mfa_required" => "true"
  }

  spec.files = %w[
    CHANGELOG.md
    CODE_OF_CONDUCT.md
    LICENSE
    README.md
    ext/fast_parameterize/extconf.rb
    ext/fast_parameterize/fast_parameterize.c
    fast_parameterize.gemspec
    lib/fast_parameterize.rb
    lib/fast_parameterize/version.rb
  ]

  spec.require_paths = %w[lib]
  spec.extensions = ["ext/fast_parameterize/extconf.rb"]
end
