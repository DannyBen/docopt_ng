require 'docopt-ng/parent_pattern'

module DocoptNG
  class Optional < ParentPattern
    def match(left, collected=nil)
      collected ||= []
      for p in self.children
        _, left, collected = p.match(left, collected)
      end
      return [true, left, collected]
    end
  end
end
