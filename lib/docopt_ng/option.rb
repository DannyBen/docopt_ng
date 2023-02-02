require 'docopt_ng/child_pattern'

module DocoptNG
  class Option < ChildPattern
    attr_reader :short, :long
    attr_accessor :argcount

    def initialize(short = nil, long = nil, argcount = 0, value = false)
      raise RuntimeError unless [0, 1].include? argcount

      @short = short
      @long = long
      @argcount = argcount
      @value = value

      @value = if (value == false) && argcount.positive?
        nil
      else
        value
      end
    end

    def self.parse(option_description)
      short = nil
      long = nil
      argcount = 0
      value = false
      options, _, description = option_description.strip.partition('  ')

      options = options.tr(',', ' ').tr('=', ' ')

      options.split.each do |s|
        if s.start_with?('--')
          long = s
        elsif s.start_with?('-')
          short = s
        else
          argcount = 1
        end
      end
      if argcount.positive?
        matched = description.scan(/\[default: (.*)\]/i)
        value = matched[0][0] if matched.count.positive?
      end
      new(short, long, argcount, value)
    end

    def single_match(left)
      left.each_with_index do |p, n|
        return [n, p] if name == p.name
      end
      [nil, nil]
    end

    def name
      long || short
    end

    def inspect
      "Option(#{short}, #{long}, #{argcount}, #{value})"
    end
  end
end
