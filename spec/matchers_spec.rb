# $Id: matchers_spec.rb 986 2007-05-09 07:48:34Z pete $
# vim: ts=2 sw=2 ai expandtab

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

class CallLoggerStub
  def initialize(*call_log)
    @call_log = call_log
  end
  
  attr_reader :call_log
  
  def inspect
    "CallLoggerStub"
  end
end

describe NotAMock::Matchers::AnythingMatcher do
  
  it "should match if a method was called" do
    @object = CallLoggerStub.new({ :method => :length, :args => [], :result => nil })
    @matcher = have_been_called
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub was called"
  end

  it "should not match if a method wasn't called" do
    @object = CallLoggerStub.new()
    @matcher = have_been_called
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub was never called"
  end
    
end

describe NotAMock::Matchers::MethodMatcher do
  
  before do
    @object = CallLoggerStub.new({ :method => :length, :args => [], :result => 13 })
  end
  
  it "should match a called method" do
    @matcher = have_received(:length)
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received length"
  end
  
  it "should not match an uncalled method" do
    @matcher = have_received(:width)
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub didn't receive width"
  end
    
end

describe NotAMock::Matchers::ArgsMatcher, " matching calls with arguments " do
  
  before do
    @object = CallLoggerStub.new(
      { :method => :length, :args => [1, 2, 3], :result => nil },
      { :method => :width,  :args => [3, 2, 1], :result => nil }
    )
  end
  
  it "should match a called method with the correct arguments" do
    @matcher = have_received(:length).with(1, 2, 3)
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received length, with args [1, 2, 3]"
  end
  
  it "should not match a called method with the wrong arguments" do
    @matcher = have_received(:width).with(1, 2, 3)
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub received width, but not with args [1, 2, 3]"
  end

end


describe NotAMock::Matchers::ArgsMatcher, " matching calls without arguments" do
  
  before do
    @object = CallLoggerStub.new(
      { :method => :length, :args => [1, 2, 3], :result => nil },
      { :method => :width,  :args => [], :result => nil }
    )    
  end
  
  it "should match a method called without arguments" do
    @matcher = have_received(:width).without_args
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received width, without args"    
  end
  
  it "should not match a method called with arguments" do
    @matcher = have_received(:length).without_args
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub received length, but not without args"    
  end
  
end

describe NotAMock::Matchers::ResultMatcher do
  
  before do
    @object = CallLoggerStub.new(
      { :method => :length, :args => [], :result => 13 },
      { :method => :width,  :args => [], :result => 42 }
    )    
  end

  it "should match a method that returned the correct result" do
    @matcher = have_received(:length).and_returned(13)
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received length, and returned 13"
  end
  
  it "should not match a method the returned the wrong result" do
    @matcher = have_received(:width).and_returned(13)
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub received width, but didn't return 13"
  end
    
end

describe NotAMock::Matchers::TimesMatcher do
  
  before do
    @object = CallLoggerStub.new(
      { :method => :once,   :args => [], :result => nil },
      { :method => :twice,  :args => [], :result => nil },
      { :method => :twice,  :args => [], :result => nil },
      { :method => :thrice, :args => [], :result => nil },
      { :method => :thrice, :args => [], :result => nil },
      { :method => :thrice, :args => [], :result => nil }
    )
  end
  
  it "should match a method that was called once" do
    @matcher = have_received(:once).once
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received once, once"
  end

  it "should match a method that was called twice" do
    @matcher = have_received(:twice).twice
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received twice, twice"
  end
  
  it "should match a method that was called 3 times" do
    @matcher = have_received(:thrice).exactly(3).times
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received thrice, 3 times"
  end  
  
  it "should not match a method a method that was called the wrong number of times" do
    @matcher = have_received(:thrice).once
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub received thrice, but 3 times"
  end
  
end

describe "A chain of matchers" do
  
  before do
    @object = CallLoggerStub.new({ :method => :length, :args => [1, 2, 3], :result => 42 })
  end
  
  it "should match the correct method, args, and result" do
    @matcher = have_received(:length).with(1, 2, 3).and_returned(42)
    @matcher.matches?(@object).should be_true
    @matcher.negative_failure_message.should == "CallLoggerStub received length, with args [1, 2, 3], and returned 42"
  end
  
  it "should not match the correct method, but with the incorrect args" do
    @matcher = have_received(:length).with(3, 2, 1).and_returned(42)
    @matcher.matches?(@object).should be_false
    @matcher.failure_message.should == "CallLoggerStub received length, but not with args [3, 2, 1]"
  end
  
end
