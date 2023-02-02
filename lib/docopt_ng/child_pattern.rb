require 'docopt_ng/pattern'

module DocoptNG
  class ChildPattern < Pattern
    attr_accessor :name, :value

    def initialize(name, value = nil)
      @name = name
      @value = value
    end

    def inspect
      "#{self.class.name}(#{name}, #{value})"
    end

    def flat(*types)
      if types.empty? || types.include?(self.class)
        [self]
      else
        []
      end
    end

    def match(left, collected = nil)
      collected ||= []
      pos, match = single_match(left)

      return [false, left, collected] if match.nil?

      left_ = left.dup
      left_.slice!(pos)

      same_name = collected.select { |a| a.name == name }
      if @value.is_a?(Array) || @value.is_a?(Integer)
        increment = if @value.is_a? Integer
          1
        else
          match.value.is_a?(String) ? [match.value] : match.value
        end
        if same_name.count.zero?
          match.value = increment
          return [true, left_, collected + [match]]
        end
        same_name[0].value += increment
        return [true, left_, collected]
      end

      [true, left_, collected + [match]]
    end
  end
end
