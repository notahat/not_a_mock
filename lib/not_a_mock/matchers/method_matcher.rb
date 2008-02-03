require 'not_a_mock/matchers/call_matcher'

module NotAMock
  module Matchers
    # Matcher for
    #   object.should have_received(...)
    class MethodMatcher < CallMatcher
  
      def initialize(method, parent = nil)
        super parent
        @method = method
      end
  
      def matches_without_parents?
        @calls = CallRecorder.instance.calls_by_object_and_method(@object, @method)
        !@calls.empty?
      end
  
      def failure_message_without_parents
        if matched?
          " received #{@method}"
        else
          " didn't receive #{@method}"
        end
      end
  
    end
  end
end
