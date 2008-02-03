module NotAMock
  # == Message Assertions
  # 
  # You can assert that an object should have received particular messages:
  # 
  #   object.should have_received(:message)
  #   object.should_not have_received(:message)
  # 
  # Further restrictions cannot be added after +should_not have_received+.
  # 
  # You can also make general assertions about whether an object should have
  # received any messages:
  # 
  #   object.should have_been_called
  #   object.should_not have_been_called
  # 
  # == Argument Assertions
  # 
  # You can assert that a call was made with or without arguments:
  # 
  #   object.should have_received(:message).with(arg1, arg2, ...)
  #   object.should have_received(:message).without_args
  # 
  # == Return Value Assertions
  # 
  #   object.should have_received(:message).and_returned(return_value)
  #   object.should have_received(:message).with(arg1, arg2, ...).and_returned(return_value)
  # 
  # == Count Assertions
  # 
  #   object.should have_received(:message).once
  #   object.should have_received(:message).with(arg1, arg2, ...).twice
  #   object.should have_received(:message).with(arg1, arg2, ...).and_returned(return_value).exactly(n).times
  #   object.should have_been_called.exactly(n).times
  # 
  # Any count specifier must go at the end of the expression.
  # 
  # The exception to this rule is +once+, which allows things like this:
  # 
  #   object.should have_received(:message).once.with(arg1, arg2, ...).and_returned(return_value)
  # 
  # which verifies that +message+ was called only once, and that call had
  # the given arguments and return value.
  # 
  # Note that this is subtly different from:
  # 
  #   object.should have_received(:message).with(arg1, arg2, ...).and_returned(return_value).once
  # 
  # which verifies that +message+ was called with the given arguments and
  # return value only once. It may, however, have been called with different
  # arguments and return value at other times.
  #
  # == Assertion Failures
  #
  # FIXME: Write some docs about the nice error messages.
  module Matchers
  end
end

def have_been_called
  NotAMock::Matchers::AnythingMatcher.new
end

def have_received(method)
  NotAMock::Matchers::MethodMatcher.new(method)
end
