require 'docopt-ng/docopt'

doc = <<DOCOPT
Usage: #{__FILE__} [-h | --help] (ODD EVEN)...

Example, try:
  #{__FILE__} 1 2 3 4

Options:
  -h, --help

DOCOPT

begin
  pp Docopt::docopt(doc)
rescue Docopt::Exit => e
  puts e.message
end