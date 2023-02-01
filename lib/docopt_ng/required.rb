require 'docopt_ng/parent_pattern'

module DocoptNG
  class Required < ParentPattern
    def match(left, collected = nil)
      collected ||= []
      l = left
      c = collected

      children.each do |p|
        matched, l, c = p.match(l, c)
        unless matched
          return [false, left, collected]
        end
      end
      [true, l, c]
    end
  end
end
