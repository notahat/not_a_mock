require 'notamock/matchers/call_matcher'

module Notamock
  module Matchers
    # Matcher for +once+, +twice+, and
    #   exactly(n).times
    class TimesMatcher < CallMatcher
  
      def initialize(times, parent = nil)
        super parent
        @times = times
      end
  
      def matches_without_parents?
        @calls = @parent.calls
        @calls.length == @times
      end
  
      def failure_message_without_parents
        if matched?
          ", #{times_in_english(@parent.calls.length)}"
        else
          ", but #{times_in_english(@parent.calls.length, true)}"
        end
      end
  
      def times
        self
      end
  
    private

      def times_in_english(times, only = false)
        case times
          when 1
            only ? "only once" : "once"
          when 2
            "twice"
          else
            "#{times} times"
        end
      end
  
    end
  end
end
