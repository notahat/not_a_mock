module Notamock
  module Matchers
    class CallMatcher
  
      def initialize(parent = nil)
        @parent = parent
      end
  
      def matches?(object)
        @object = object
        @matched = parent_matches? && matches_without_parents?
      end
  
      def matched?; @matched end
      
      attr_reader :calls
  
      def failure_message
        if parent_matched?
          parent_failure_message + failure_message_without_parents
        else
          parent_failure_message
        end
      end
      
      def negative_failure_message
        failure_message
      end

      def with(*args)
        ArgsMatcher.new(args, self)
      end
  
      def without_args
        ArgsMatcher.new([], self)
      end
  
      def and_returned(result)
        ResultMatcher.new(result, self)
      end
  
      def exactly(n)
        TimesMatcher.new(n, self)
      end
      def once;  exactly(1) end
      def twice; exactly(2) end
  
    protected
    
      def parent_matches?
        @parent.nil? || @parent.matches?(@object)
      end
      
      def parent_matched?
        @parent.nil? || @parent.matched?
      end
      
      def parent_failure_message
        @parent ? @parent.failure_message : @object.inspect
      end

    end
  end
end
