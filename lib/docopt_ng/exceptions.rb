module DocoptNG
  class DocoptLanguageError < SyntaxError
  end

  class Exit < RuntimeError
    class << self
      attr_reader :usage

      def usage=(text)
        @usage = text || ''
      end
    end

    attr_reader :exit_code

    def initialize(message = '', exit_code: nil)
      @exit_code = exit_code || 1
      super "#{message}\n#{self.class.usage}".strip
    end
  end
end
