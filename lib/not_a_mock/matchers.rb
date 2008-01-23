module NotAMock
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
      
      attr_reader :call_log
  
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


    # Matcher for
    #   object.should have_been_called
    class AnythingMatcher < CallMatcher
  
      def initialize(parent = nil)
        super parent
      end
  
      def matches_without_parents?
        @call_log = @object.call_log
        !@call_log.empty?
      end
  
      def failure_message_without_parents
        if matched?
          " was called"
        else
          " was never called"
        end
      end
  
    end


    # Matcher for
    #   object.should have_received(...)
    class MethodMatcher < CallMatcher
  
      def initialize(method, parent = nil)
        super parent
        @method = method
      end
  
      def matches_without_parents?
        @call_log = @object.call_log.select {|entry| entry[:method] == @method }
        !@call_log.empty?
      end
  
      def failure_message_without_parents
        if matched?
          " received #{@method}"
        else
          " didn't receive #{@method}"
        end
      end
  
    end


    # Matcher for
    #  with(...)
    class ArgsMatcher < CallMatcher
  
      def initialize(args, parent = nil)
        super parent
        @args = args
      end
  
      def matches_without_parents?
        @call_log = @parent.call_log.select {|entry| entry[:args] == @args }
        !@call_log.empty?
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


    # Matcher for
    #   and_returned(...)
    class ResultMatcher < CallMatcher
  
      def initialize(result, parent = nil)
        super parent
        @result = result
      end
  
      def matches_without_parents?
        @call_log = @parent.call_log.select {|entry| entry[:result] == @result }
        !@call_log.empty?
      end
  
      def failure_message_without_parents
        if matched?
          ", and returned #{@result.inspect}"
        else
          ", but didn't return #{@result.inspect}"
        end
      end
  
    end


    # Matcher for +once+, +twice+, and
    #   exactly(n).times
    class TimesMatcher < CallMatcher
  
      def initialize(times, parent = nil)
        super parent
        @times = times
      end
  
      def matches_without_parents?
        @call_log = @parent.call_log
        @call_log.length == @times
      end
  
      def failure_message_without_parents
        if matched?
          ", #{times_in_english(@parent.call_log.length)}"
        else
          ", but #{times_in_english(@parent.call_log.length, true)}"
        end
      end
  
      def times
        self
      end
  
    private

      def times_in_english(times, only = false)
        case times
          when 1
            only ? 'only once' : 'once'
          when 2
            'twice'
          else
            "#{times} times"
        end
      end
  
    end

  end # module Matchers
end # module NotAMock


def have_been_called
  NotAMock::Matchers::AnythingMatcher.new
end

def have_received(method)
  NotAMock::Matchers::MethodMatcher.new(method)
end
