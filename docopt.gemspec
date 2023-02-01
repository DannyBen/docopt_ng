lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'docopt/version'

Gem::Specification.new do |s|
  s.name        = 'docopt'
  s.version     = Docopt::VERSION
  s.summary     = "A command line option parser, that will make you smile."
  s.description = "Isn't it awesome how `optparse` and other option parsers generate help and usage-messages based on your code?! Hell no!\nYou know what's awesome? It's when the option parser *is* generated based on the help and usage-message that you write in a docstring! That's what docopt does!"
  s.authors     = [
    "Alex Speller",
    "Blake Williams",
    "Danny Ben Shitrit",
    "Nima Johari",
    "Vladimir Keleshev",
  ]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.homepage = 'https://github.com/dannyben/docopt'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.7.0'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/docopt/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/docopt/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://docopt.org/',
    'source_code_uri'       => 'https://github.com/DannyBen/docopt',
    'rubygems_mfa_required' => 'true',
  }
end
