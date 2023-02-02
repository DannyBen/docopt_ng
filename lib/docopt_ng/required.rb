require 'docopt_ng/parent_pattern'

module DocoptNG
  class Required < ParentPattern
    def match(left, collected = nil)
      collected ||= []
      l = left
      c = collected

      children.each do |p|
        matched, l, c = p.match(l, c)
        return [false, left, collected] unless matched
      end
      [true, l, c]
    end
  end
end
