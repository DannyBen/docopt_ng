require 'docopt_ng/argument'

module DocoptNG
  class Command < Argument
    def initialize(name, value = false)
      @name = name
      @value = value
    end

    def single_match(left)
      left.each_with_index do |p, n|
        next unless p.instance_of?(Argument)
        return n, Command.new(name, true) if p.value == name

        break
      end
      [nil, nil]
    end
  end
end
