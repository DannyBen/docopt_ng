require 'docopt-ng/parent_pattern'

module DocoptNG
  class Either < ParentPattern
    def match(left, collected=nil)
      collected ||= []
      outcomes = []
      for p in self.children
        matched, _, _ = found = p.match(left, collected)
        if matched
          outcomes << found
        end
      end

      if outcomes.count > 0
        return outcomes.min_by do |outcome|
          outcome[1] == nil ? 0 : outcome[1].count
        end
      end
      return [false, left, collected]
    end
  end
end
