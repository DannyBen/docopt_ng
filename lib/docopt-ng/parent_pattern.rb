require 'docopt-ng/pattern'

module DocoptNG
  class ParentPattern < Pattern
    attr_accessor :children

    def initialize(*children)
      @children = children
    end

    def inspect
      childstr = self.children.map { |a| a.inspect }
      return "#{self.class.name}(#{childstr.join(", ")})"
    end

    def flat(*types)
      if types.include?(self.class)
        [self]
      else
        self.children.map { |c| c.flat(*types) }.flatten
      end
    end
  end
end