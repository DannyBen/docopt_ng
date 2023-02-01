require 'docopt-ng/child_pattern'

module DocoptNG
  class Argument < ChildPattern

    def single_match(left)
      left.each_with_index do |p, n|
        if p.class == Argument
          return [n, Argument.new(self.name, p.value)]
        end
      end
      return [nil, nil]
    end

    def self.parse(class_, source)
      name = /(<\S*?>)/.match(source)[0]
      value = /\[default: (.*)\]/i.match(source)
      class_.new(name, (value ? value[0] : nil))
    end
  end
end