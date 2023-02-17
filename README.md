# Docopt – command line option parser, that will make you smile

[![Gem Version](https://badge.fury.io/rb/docopt_ng.svg)](https://badge.fury.io/rb/docopt_ng)
[![Build Status](https://github.com/DannyBen/docopt_ng/workflows/Test/badge.svg)](https://github.com/DannyBen/docopt_ng/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/31af96bab7913f71dc28/maintainability)](https://codeclimate.com/github/DannyBen/docopt_ng/maintainability)

---

This is a detached fork of the original [docopt.rb](https://github.com/docopt/docopt.rb).

- For a drop-in replacement, simply `require 'docopt_ng/docopt'`
- Otherwise, use `require 'docopt_ng'` and `DocoptNG` instead of `Docopt`.

---

This is the ruby port of [`docopt`](https://github.com/docopt/docopt),
the awesome option parser written originally in python.

Isn't it awesome how `optparse` and `argparse` generate help messages
based on your code?!

*Hell no!*  You know what's awesome?  It's when the option parser *is* generated
based on the beautiful help message that you write yourself!  This way
you don't need to write this stupid repeatable parser-code, and instead can
write only the help message--*the way you want it*.

`docopt` helps you create most beautiful command-line interfaces *easily*:

```ruby
require "docopt_ng/docopt"

doc = <<DOCOPT
Naval Fate.

Usage:
  #{__FILE__} ship new <name>...
  #{__FILE__} ship <name> move <x> <y> [--speed=<kn>]
  #{__FILE__} ship shoot <x> <y>
  #{__FILE__} mine (set|remove) <x> <y> [--moored|--drifting]
  #{__FILE__} -h | --help
  #{__FILE__} --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --speed=<kn>  Speed in knots [default: 10].
  --moored      Moored (anchored) mine.
  --drifting    Drifting mine.

DOCOPT

begin
  pp Docopt::docopt(doc)
rescue Docopt::Exit => e
  puts e.message
  exit e.exit_code
end
```

Beat that! The option parser is generated based on the docstring above that is
passed to `docopt` function.  `docopt` parses the usage pattern
(`Usage: ...`) and option descriptions (lines starting with dash "`-`") and
ensures that the program invocation matches the usage pattern; it parses
options, arguments and commands based on that. The basic idea is that
*a good help message has all necessary information in it to make a parser*.

## Installation


```shell
$ gem install docopt_ng
```


## API

`Docopt` takes 1 required and 1 optional argument:

- `doc` should be a string that
  describes **options** in a human-readable format, that will be parsed to create
  the option parser.  The simple rules of how to write such a docstring
  (in order to generate option parser from it successfully) are given in the next
  section. Here is a quick example of such a string:

        Usage: your_program.rb [options]

        -h --help     Show this.
        -v --verbose  Print more text.
        --quiet       Print less text.
        -o FILE       Specify output file [default: ./test.txt].

  The optional second argument contains a hash of additional data to influence
  docopt. The following keys are supported: 

- `help`, by default `true`, specifies whether the parser should automatically
  print the usage-message (supplied as `doc`) in case `-h` or `--help` options
  are encountered. After showing the usage-message, the program will terminate.
  If you want to handle `-h` or `--help` options manually (as all other options),
  set `help=false`.

- `version`, by default `nil`, is an optional argument that specifies the
  version of your program. If supplied, then, if the parser encounters
  `--version` option, it will print the supplied version and terminate.
  `version` could be any printable object, but most likely a string,
  e.g. `'2.1.0rc1'`.

Note, when `docopt` is set to automatically handle `-h`, `--help` and
`--version` options, you still need to mention them in the options description
(`doc`) for your users to know about them.

The **return** value is just a hash with options, arguments and commands,
with keys spelled exactly like in a help message
(long versions of options are given priority). For example, if you invoke
the top example as:

```
$ naval_fate.rb ship Guardian move 100 150 --speed=15
```

the return hash will be::

```ruby
{
  "ship" => true,
  "new" => false,
  "<name>" => ["Guardian"],
  "move" => true,
  "<x>" => "100",
  "<y>" => "150",
  "--speed" => "15",
  "shoot" => false,
  "mine" => false,
  "set" => false,
  "remove" => false,
  "--moored" => false,
  "--drifting" => false,
  "--help" => false,
  "--version" => false
}
```

## Help message format

This port of docopt follows the docopt help message format.
You can find more details at
[official docopt git repo](https://github.com/docopt/docopt#help-message-format)


## Examples

The [examples directory](examples) contains several examples which cover most
aspects of the docopt functionality. 
