require 'not_a_mock/matchers/call_matcher'

module NotAMock
  module Matchers
    # Matcher for
    #  with(...)
    #
    # == Argument Matchers
    #
    # Not A Mock supports the use of RSpec's patterns for argument matching
    # in mocks, and extends them. The most useful are listed below.
    #
    # === Anything Matcher
    #
    # The +anything+ pattern will match any value. For example:
    #
    #   object.should have_received(:message).with(1, anything, 3)
    #
    # will match the following calls:
    #
    #   object.message(1, 2, 3)
    #   object.message(1, 'Boo!', 3)
    #
    # but not:
    #
    #    object.message(3, 2, 1)
    #    object.message(1, 2, 3, 4)
    #
    # === In Any Order Matcher
    #
    # The +in_any_order+ pattern will match an array argument, but won't care
    # about order of elements in the array. For example:
    #
    #   object.should have_received(:message).with(in_any_order([3, 2, 1]))
    #
    # will match the following calls:
    #
    #   object.message([3, 2, 1])
    #   object.message([1, 2, 3])
    #
    # but not:
    #
    #   object.message([1, 2, 3, 4])
    class ArgsMatcher < CallMatcher
  
      def initialize(args, parent = nil)
        super parent
        @args = args
      end
  
      def matches_without_parents?
        @calls = @parent.calls.select {|entry| @args == entry[:args] }
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
