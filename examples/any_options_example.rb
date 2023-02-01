require 'docopt-ng/docopt'

doc = <<DOCOPT
Example of program which uses [options] shortcut in pattern.

Usage:
  #{__FILE__} [options] <port>

Options:
  -h --help                show this help message and exit
  --version                show version and exit
  -n, --number N           use N as a number
  -t, --timeout TIMEOUT    set timeout TIMEOUT seconds
  --apply                  apply changes to database
  -q                       operate in quiet mode

DOCOPT


begin
  pp Docopt::docopt(doc, version: '1.0.0rc2')
rescue Docopt::Exit => e
  puts e.message
end
