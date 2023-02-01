require 'docopt-ng/docopt'

doc = <<DOCOPT
Usage:
  #{__FILE__} tcp <host> <port> [--timeout=<seconds>]
  #{__FILE__} serial <port> [--baud=9600] [--timeout=<seconds>]
  #{__FILE__} -h | --help | --version

DOCOPT

begin
  pp Docopt::docopt(doc)
rescue Docopt::Exit => e
  puts e.message
end