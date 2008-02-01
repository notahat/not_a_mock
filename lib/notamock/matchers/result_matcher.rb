require 'notamock/matchers/call_matcher'

module Notamock
  module Matchers
    # Matcher for
    #   and_returned(...)
    class ResultMatcher < CallMatcher
  
      def initialize(result, parent = nil)
        super parent
        @result = result
      end
  
      def matches_without_parents?
        @calls = @parent.calls.select {|entry| entry[:result] == @result }
        !@calls.empty?
      end
  
      def failure_message_without_parents
        if matched?
          ", and returned #{@result.inspect}"
        else
          ", but didn't return #{@result.inspect}"
        end
      end
  
    end
  end
end
