require 'docopt-ng/exceptions'
require 'docopt-ng/pattern'
require 'docopt-ng/child_pattern'
require 'docopt-ng/parent_pattern'
require 'docopt-ng/argument'
require 'docopt-ng/command'
require 'docopt-ng/option'
require 'docopt-ng/required'
require 'docopt-ng/optional'
require 'docopt-ng/any_options'
require 'docopt-ng/one_or_more'
require 'docopt-ng/either'
require 'docopt-ng/token_stream'

module DocoptNG
  class << self
    def parse_long(tokens, options)
      long, eq, value = tokens.move.partition('=')
      unless long.start_with?('--')
        raise RuntimeError
      end

      value = nil if eq == value and eq == ''

      similar = options.select { |o| o.long and o.long == long }

      if tokens.error == Exit and similar == []
        similar = options.select { |o| o.long and o.long.start_with?(long) }
      end

      if similar.count > 1
        ostr = similar.map(&:long).join(', ')
        raise tokens.error, "#{long} is not a unique prefix: #{ostr}?"
      elsif similar.count < 1
        argcount = (eq == '=' ? 1 : 0)
        o = Option.new(nil, long, argcount)
        options << o
        if tokens.error == Exit
          o = Option.new(nil, long, argcount, (argcount == 1 ? value : true))
        end
      else
        s0 = similar[0]
        o = Option.new(s0.short, s0.long, s0.argcount, s0.value)
        if o.argcount.zero?
          unless value.nil?
            raise tokens.error, "#{o.long} must not have an argument"
          end
        elsif value.nil?
          if tokens.current.nil?
            raise tokens.error, "#{o.long} requires argument"
          end

          value = tokens.move
        end
        if tokens.error == Exit
          o.value = (value.nil? ? true : value)
        end
      end
      [o]
    end

    def parse_shorts(tokens, options)
      token = tokens.move
      unless token.start_with?('-') && !token.start_with?('--')
        raise RuntimeError
      end

      left = token[1..]
      parsed = []
      while left != ''
        short = "-#{left[0]}"
        left = left[1..]
        similar = options.select { |o| o.short == short }
        if similar.count > 1
          raise tokens.error, "#{short} is specified ambiguously #{similar.count} times"
        elsif similar.count < 1
          o = Option.new(short, nil, 0)
          options << o
          if tokens.error == Exit
            o = Option.new(short, nil, 0, true)
          end
        else
          s0 = similar[0]
          o = Option.new(short, s0.long, s0.argcount, s0.value)
          value = nil
          if o.argcount != 0
            if left == ''
              if tokens.current.nil?
                raise tokens.error, "#{short} requires argument"
              end

              value = tokens.move
            else
              value = left
              left = ''
            end
          end
          if tokens.error == Exit
            o.value = (value.nil? ? true : value)
          end
        end

        parsed << o
      end
      parsed
    end

    def parse_pattern(source, options)
      tokens = TokenStream.new(source.gsub(/([\[\]()|]|\.\.\.)/, ' \1 '), DocoptLanguageError)

      result = parse_expr(tokens, options)
      unless tokens.current.nil?
        raise tokens.error, "unexpected ending: #{tokens.join(' ')}"
      end

      Required.new(*result)
    end

    def parse_expr(tokens, options)
      seq = parse_seq(tokens, options)
      if tokens.current != '|'
        return seq
      end

      result = seq.count > 1 ? [Required.new(*seq)] : seq

      while tokens.current == '|'
        tokens.move
        seq = parse_seq(tokens, options)
        result += seq.count > 1 ? [Required.new(*seq)] : seq
      end
      result.count > 1 ? [Either.new(*result)] : result
    end

    def parse_seq(tokens, options)
      result = []
      stop = [nil, ']', ')', '|']
      until stop.include?(tokens.current)
        atom = parse_atom(tokens, options)
        if tokens.current == '...'
          atom = [OneOrMore.new(*atom)]
          tokens.move
        end
        result += atom
      end
      result
    end

    def parse_atom(tokens, options)
      token = tokens.current
      result = []

      if ['(', '['].include? token
        tokens.move
        if token == '('
          matching = ')'
          pattern = Required
        else
          matching = ']'
          pattern = Optional
        end
        result = pattern.new(*parse_expr(tokens, options))
        if tokens.move != matching
          raise tokens.error, "unmatched '#{token}'"
        end

        [result]
      elsif token == 'options'
        tokens.move
        [AnyOptions.new]
      elsif token.start_with?('--') and token != '--'
        parse_long(tokens, options)
      elsif token.start_with?('-') and !['-', '--'].include? token
        parse_shorts(tokens, options)
      elsif (token.start_with?('<') and token.end_with?('>')) or (token.upcase == token && token.match(/[A-Z]/))
        [Argument.new(tokens.move)]
      else
        [Command.new(tokens.move)]
      end
    end

    def parse_argv(tokens, options, options_first = false)
      parsed = []
      until tokens.current.nil?
        if tokens.current == '--'
          return parsed + tokens.map { |v| Argument.new(nil, v) }
        elsif tokens.current.start_with?('--')
          parsed += parse_long(tokens, options)
        elsif tokens.current.start_with?('-') and tokens.current != '-'
          parsed += parse_shorts(tokens, options)
        elsif options_first
          return parsed + tokens.map { |v| Argument.new(nil, v) }
        else
          parsed << Argument.new(nil, tokens.move)
        end
      end
      parsed
    end

    def parse_defaults(doc)
      split = doc.split(/^ *(<\S+?>|-\S+?)/).drop(1)
      split = split.each_slice(2).reject { |pair| pair.count != 2 }.map { |s1, s2| s1 + s2 }
      split.select { |s| s.start_with?('-') }.map { |s| Option.parse(s) }
    end

    def printable_usage(doc)
      usage_split = doc.split(/([Uu][Ss][Aa][Gg][Ee]:)/)
      if usage_split.count < 3
        raise DocoptLanguageError, '"usage:" (case-insensitive) not found.'
      end
      if usage_split.count > 3
        raise DocoptLanguageError, 'More than one "usage:" (case-insensitive).'
      end

      usage_split.drop(1).join.split(/\n\s*\n/)[0].strip
    end

    def formal_usage(printable_usage)
      pu = printable_usage[/usage:(.*)/mi, 1]

      lines = pu.lines(chomp: true).reject(&:empty?).map do |a|
        "( #{a.split.drop(1).join(' ')} )"
      end

      lines.join ' | '
    end

    def dump_patterns(pattern, indent = 0)
      ws = ' ' * 4 * indent
      out = ''
      if pattern.instance_of?(Array)
        if pattern.count.positive?
          out << ws << "[\n"
          for p in pattern
            out << dump_patterns(p, indent + 1).rstrip << "\n"
          end
          out << ws << "]\n"
        else
          out << ws << "[]\n"
        end

      elsif pattern.class.ancestors.include?(ParentPattern)
        out << ws << pattern.class.name << "(\n"
        for p in pattern.children
          out << dump_patterns(p, indent + 1).rstrip << "\n"
        end
        out << ws << ")\n"

      else
        out << ws << pattern.inspect
      end
      out
    end

    def extras(help, version, options, doc)
      if help and options.any? { |o| ['-h', '--help'].include?(o.name) && o.value }
        Exit.set_usage(nil)
        raise Exit, doc.strip
      end
      return unless version and options.any? { |o| o.name == '--version' && o.value }

      Exit.set_usage(nil)
      raise Exit, version
    end

    def docopt(doc, params = {})
      default = { version: nil, argv: nil, help: true, options_first: false }
      params = default.merge(params)
      params[:argv] = ARGV unless params[:argv]

      Exit.set_usage(printable_usage(doc))
      options = parse_defaults(doc)
      pattern = parse_pattern(formal_usage(Exit.usage), options)
      argv = parse_argv(TokenStream.new(params[:argv], Exit), options, params[:options_first])
      pattern_options = pattern.flat(Option).uniq
      pattern.flat(AnyOptions).each do |ao|
        doc_options = parse_defaults(doc)
        ao.children = doc_options.reject { |o| pattern_options.include?(o) }.uniq
      end
      extras(params[:help], params[:version], argv, doc)

      matched, left, collected = pattern.fix.match(argv)
      collected ||= []

      if matched and left.count.zero?
        return (pattern.flat + collected).map { |a| [a.name, a.value] }.to_h
      end

      raise Exit
    end
  end
end
