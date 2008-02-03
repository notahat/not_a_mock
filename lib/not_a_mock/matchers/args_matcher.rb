require 'not_a_mock/matchers/call_matcher'

module NotAMock
  module Matchers
    # Matcher for
    #  with(...)
    class ArgsMatcher < CallMatcher
  
      def initialize(args, parent = nil)
        super parent
        @args = args
      end
  
      def matches_without_parents?
        @calls = @parent.calls.select {|entry| entry[:args] == @args }
        !@calls.empty?
      end
  
      def failure_message_without_parents
        if matched?
          if @args.empty?
            ", without args"
          else
            ", with args #{@args.inspect}"
          end
        else
          if @args.empty?
            ", but not without args"
          else
            ", but not with args #{@args.inspect}"
          end
        end
      end
  
    end
  end
end
