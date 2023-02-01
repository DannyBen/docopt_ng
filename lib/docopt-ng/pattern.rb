module DocoptNG
  class Pattern
    attr_accessor :children

    def ==(other)
      inspect == other.inspect
    end

    def to_str
      inspect
    end

    def dump
      puts ::Docopt.dump_patterns(self)
    end

    def fix
      fix_identities
      fix_repeating_arguments
      self
    end

    def fix_identities(uniq = nil)
      unless instance_variable_defined?(:@children)
        return self
      end

      uniq ||= flat.uniq

      @children.each_with_index do |c, i|
        if c.instance_variable_defined?(:@children)
          c.fix_identities(uniq)
        else
          unless uniq.include?(c)
            raise RuntimeError
          end

          @children[i] = uniq[uniq.index(c)]
        end
      end
    end

    def fix_repeating_arguments
      either.children.map(&:children).each do |case_|
        case_.select { |c| case_.count(c) > 1 }.each do |e|
          if e.instance_of?(Argument) or (e.instance_of?(Option) and e.argcount.positive?)
            if e.value.nil?
              e.value = []
            elsif e.value.class != Array
              e.value = e.value.split
            end
          end
          if e.instance_of?(Command) or (e.instance_of?(Option) and e.argcount.zero?)
            e.value = 0
          end
        end
      end

      self
    end

    def either
      ret = []
      groups = [[self]]
      while groups.count.positive?
        children = groups.shift
        types = children.map(&:class)

        if types.include?(Either)
          either = children.select { |child| child.instance_of?(Either) }[0]
          children.slice!(children.index(either))
          for c in either.children
            groups << ([c] + children)
          end
        elsif types.include?(Required)
          required = children.select { |child| child.instance_of?(Required) }[0]
          children.slice!(children.index(required))
          groups << (required.children + children)

        elsif types.include?(Optional)
          optional = children.select { |child| child.instance_of?(Optional) }[0]
          children.slice!(children.index(optional))
          groups << (optional.children + children)

        elsif types.include?(AnyOptions)
          anyoptions = children.select { |child| child.instance_of?(AnyOptions) }[0]
          children.slice!(children.index(anyoptions))
          groups << (anyoptions.children + children)

        elsif types.include?(OneOrMore)
          oneormore = children.select { |child| child.instance_of?(OneOrMore) }[0]
          children.slice!(children.index(oneormore))
          groups << ((oneormore.children * 2) + children)

        else
          ret << children
        end
      end

      args = ret.map { |e| Required.new(*e) }
      Either.new(*args)
    end
  end
end
