# $Id: call_logging_spec.rb 986 2007-05-09 07:48:34Z pete $
# vim: ts=2 sw=2 ai expandtab

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

describe "A string with logging enabled on some methods" do
  
  before do
    @s = "Hello, world!"
    @s.log_calls_to(:replace)
    @s.log_calls_to(:length)
  end
  
  it "should log a single call" do
    @s.length
    @s.call_log.should == [ { :method => :length, :args => [], :result => 13 } ]
  end
  
  it "should log a call to each method" do
    @s.replace "Goodbye, world!"
    @s.length
    @s.call_log.should == [
      { :method => :replace, :args => ["Goodbye, world!"], :result => "Goodbye, world!" },
      { :method => :length, :args => [], :result => 15 }
    ]
  end
  
  it "should not log a call to a method not marked for logging" do
    @s.upcase
    @s.call_log.should == []
  end
  
end
