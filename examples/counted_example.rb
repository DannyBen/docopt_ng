require 'docopt_ng/docopt'

doc = <<~DOCOPT
  Usage: #{__FILE__} --help
         #{__FILE__} -v...
         #{__FILE__} go [go]
         #{__FILE__} (--path=<path>)...
         #{__FILE__} <file> <file>

  Try: #{__FILE__} -vvvvvvvvvv
       #{__FILE__} go go
       #{__FILE__} --path ./here --path ./there
       #{__FILE__} this.txt that.txt

DOCOPT

begin
  pp Docopt.docopt(doc)
rescue Docopt::Exit => e
  puts e.message
  exit e.exit_code
end
