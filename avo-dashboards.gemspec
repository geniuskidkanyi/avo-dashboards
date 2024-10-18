require_relative 'lib/avo/dashboards/version'
#require_relative '../avo/lib/avo/version'

Gem::Specification.new do |spec|
  spec.name = 'avo-dashboards'
  spec.version = Avo::Dashboards::VERSION
  spec.authors = ['Adrian']
  spec.email = ['adrian@adrianthedev.com']
  spec.homepage = 'https://github.com/avo-hq/avo'
  spec.summary = 'Dashboards for Avo apps.'
  spec.description = 'Dashboards for Avo apps.'
  spec.license = 'Commercial'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/avo-hq'

  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md', 'avo-dashboards.gemspec']
  end

  spec.add_dependency 'avo', '>= 3.5.1'
  spec.add_dependency 'turbo-rails'
  spec.add_dependency 'view_component', '>= 3.7.0'
  spec.add_dependency 'zeitwerk', '>= 2.6.12'
end
