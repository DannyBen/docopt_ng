require 'docopt_ng/parent_pattern'

module DocoptNG
  class OneOrMore < ParentPattern
    def match(left, collected = nil)
      raise RuntimeError if children.count != 1

      collected ||= []
      l = left
      c = collected
      l_ = nil
      matched = true
      times = 0
      while matched
        # could it be that something didn't match but changed l or c?
        matched, l, c = children[0].match(l, c)
        times += (matched ? 1 : 0)
        break if l_ == l

        l_ = l
      end

      if times.positive?
        [true, l, c]
      else
        [false, left, collected]
      end
    end
  end
end
