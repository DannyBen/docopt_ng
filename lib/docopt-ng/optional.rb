require 'docopt-ng/parent_pattern'

module DocoptNG
  class Optional < ParentPattern
    def match(left, collected = nil)
      collected ||= []
      for p in children
        _, left, collected = p.match(left, collected)
      end
      [true, left, collected]
    end
  end
end
