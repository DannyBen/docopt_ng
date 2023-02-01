lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'docopt-ng/version'

Gem::Specification.new do |s|
  s.name        = 'docopt-ng'
  s.version     = DocoptNG::VERSION
  s.summary     = 'A command line option parser that will make you smile'
  s.description = 'Parse command line arguments from nothing more than a usage message'
  s.authors     = [
    'Alex Speller',
    'Blake Williams',
    'Danny Ben Shitrit',
    'Nima Johari',
    'Vladimir Keleshev',
  ]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.homepage = 'https://github.com/dannyben/docopt-ng'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.7.0'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/docopt-ng/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/docopt-ng/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://docopt.org/',
    'source_code_uri'       => 'https://github.com/DannyBen/docopt-ng',
    'rubygems_mfa_required' => 'true',
  }
end
