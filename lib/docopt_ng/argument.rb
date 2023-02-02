require 'docopt_ng/child_pattern'

module DocoptNG
  class Argument < ChildPattern
    def single_match(left)
      left.each_with_index do |p, n|
        if p.instance_of?(Argument)
          return [n, Argument.new(name, p.value)]
        end
      end

      [nil, nil]
    end

    # TODO: This does not seem to be used, and can be the solution to having
    #       default values for arguments
    def self.parse(class_, source)
      name = /(<\S*?>)/.match(source)[0]
      value = /\[default: (.*)\]/i.match(source)
      class_.new(name, (value ? value[0] : nil))
    end
  end
end
