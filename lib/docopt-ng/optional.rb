require 'docopt-ng/parent_pattern'

module DocoptNG
  class Optional < ParentPattern
    def match(left, collected = nil)
      collected ||= []
      children.each do |p|
        _, left, collected = p.match(left, collected)
      end
      [true, left, collected]
    end
  end
end
