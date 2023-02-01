require 'docopt_ng/pattern'

module DocoptNG
  class ParentPattern < Pattern
    attr_accessor :children

    def initialize(*children)
      @children = children
    end

    def inspect
      childstr = children.map(&:inspect)
      "#{self.class.name}(#{childstr.join(', ')})"
    end

    def flat(*types)
      if types.include?(self.class)
        [self]
      else
        children.map { |c| c.flat(*types) }.flatten
      end
    end
  end
end
