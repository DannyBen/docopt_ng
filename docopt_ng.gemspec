lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'docopt_ng/version'

Gem::Specification.new do |s|
  s.name        = 'docopt_ng'
  s.version     = DocoptNG::VERSION
  s.summary     = 'A command line option parser that will make you smile'
  s.description = 'Parse command line arguments from nothing more than a usage message'
  s.authors     = [
    'Blake Williams',
    'Vladimir Keleshev',
    'Alex Speller',
    'Nima Johari',
    'Danny Ben Shitrit',
  ]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.homepage = 'https://github.com/dannyben/docopt_ng'
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.0'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/docopt_ng/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/docopt_ng/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://docopt.org/',
    'source_code_uri'       => 'https://github.com/DannyBen/docopt_ng',
    'rubygems_mfa_required' => 'true',
  }
end
