module DocoptNG
  class DocoptLanguageError < SyntaxError
  end

  class Exit < RuntimeError
    class << self
      attr_reader :usage

      def set_usage(text = nil)
        @usage = text || ''
      end
    end

    def initialize(message = '')
      super "#{message}\n#{self.class.usage}".strip
    end
  end
end
