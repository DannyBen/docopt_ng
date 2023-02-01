module DocoptNG
  class TokenStream < Array
    attr_reader :error

    def initialize(source, error)
      if !source
        source = []
      elsif source.class != ::Array
        source = source.split
      end
      super(source)
      @error = error
    end

    def move
      shift
    end

    def current
      self[0]
    end
  end
end
