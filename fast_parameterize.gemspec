# frozen_string_literal: true

require_relative 'lib/fast_parameterize/version'

Gem::Specification.new do |spec|
  spec.name    = 'fast_parameterize'
  spec.version = FastParameterize::VERSION
  spec.authors = ['Kevin Newton']
  spec.email   = ['kddnewton@gmail.com']

  spec.summary     = 'Fast String#parameterize implementation'
  spec.description = 'Provides a C-optimized method for parameterizing a string'
  spec.homepage    = 'https://github.com/kddnewton/fast_parameterize'
  spec.license     = 'MIT'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
  spec.extensions    = ['ext/fast_parameterize/extconf.rb']
end
