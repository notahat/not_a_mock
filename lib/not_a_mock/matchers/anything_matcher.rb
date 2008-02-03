require 'not_a_mock/matchers/call_matcher'

module NotAMock
  module Matchers
    # Matcher for
    #   object.should have_been_called
    class AnythingMatcher < CallMatcher
  
      def initialize(parent = nil)
        super parent
      end
  
      def matches_without_parents?
        @calls = CallRecorder.instance.calls_by_object(@object)
        !@calls.empty?
      end
  
      def failure_message_without_parents
        if matched?
          " was called"
        else
          " was never called"
        end
      end
  
    end
  end
end
