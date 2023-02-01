require 'docopt-ng/pattern'

module DocoptNG
  class ChildPattern < Pattern
    attr_accessor :name, :value

    def initialize(name, value=nil)
      @name = name
      @value = value
    end

    def inspect()
      "#{self.class.name}(#{self.name}, #{self.value})"
    end

    def flat(*types)
      if types.empty? or types.include?(self.class)
        [self]
      else
        []
      end
    end

    def match(left, collected=nil)
      collected ||= []
      pos, match = self.single_match(left)
      if match == nil
        return [false, left, collected]
      end

      left_ = left.dup
      left_.slice!(pos)

      same_name = collected.select { |a| a.name == self.name }
      if @value.is_a? Array or @value.is_a? Integer
        if @value.is_a? Integer
          increment = 1
        else
          increment = match.value.is_a?(String) ? [match.value] : match.value
        end
        if same_name.count == 0
          match.value = increment
          return [true, left_, collected + [match]]
        end
        same_name[0].value += increment
        return [true, left_, collected]
      end
      return [true, left_, collected + [match]]
    end
  end
end