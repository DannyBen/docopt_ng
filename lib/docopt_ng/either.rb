require 'docopt_ng/parent_pattern'

module DocoptNG
  class Either < ParentPattern
    def match(left, collected = nil)
      collected ||= []
      outcomes = []
      children.each do |p|
        matched, = found = p.match(left, collected)
        if matched
          outcomes << found
        end
      end

      if outcomes.count.positive?
        return outcomes.min_by do |outcome|
          outcome[1].nil? ? 0 : outcome[1].count
        end
      end
      [false, left, collected]
    end
  end
end
