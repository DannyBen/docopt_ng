require 'simplecov'
SimpleCov.start unless ENV['NOCOV']

require 'shellwords'
require 'bundler'
Bundler.require :default

require 'docopt_ng'

module RSpecMixin
  def runner(doc, argv)
    DocoptNG.docopt(doc, argv: argv)
  rescue DocoptNG::Exit => e
    "#{e.message} <exit:#{e.exit_code}>"
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.example_status_persistence_file_path = 'spec/status.txt'
end
