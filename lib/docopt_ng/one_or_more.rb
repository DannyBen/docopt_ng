require 'docopt_ng/parent_pattern'

module DocoptNG
  class OneOrMore < ParentPattern
    def match(left, collected = nil)
      if children.count != 1
        raise RuntimeError
      end

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
        if l_ == l
          break
        end

        l_ = l
      end
      if times >= 1
        return [true, l, c]
      end

      [false, left, collected]
    end
  end
end
