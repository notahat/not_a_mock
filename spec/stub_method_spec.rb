# $Id: stub_method_spec.rb 992 2007-05-17 05:57:58Z pete $
# vim: ts=2 sw=2 ai expandtab

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

describe "An object with an existing instance method stubbed" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:length => 42)
  end
  
  it "should return the stubbed result" do
    @object.length.should == 42
  end
  
  it "should return the original result after stubbing is removed" do
    @object.remove_logging_and_stubbing
    @object.length.should == 13
  end
  
  it "should return the original result after all stubbing is removed" do
    Object.remove_all_logging_and_stubbing
    @object.length.should == 13
  end
  
end

describe "An object with a new instance method stubbed" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:blah => 42)
  end
  
  it "should return the stubbed result" do
    @object.blah.should == 42
  end
  
  it "should raise a NoMethodError when the method is called after stubbing is removed" do
    @object.remove_logging_and_stubbing
    lambda { @object.blah }.should raise_error(NoMethodError)
  end
  
  it "should raise a NoMethodError when the method is called after all stubbing is removed" do
    Object.remove_all_logging_and_stubbing
    lambda { @object.blah }.should raise_error(NoMethodError)
  end
  
end

describe "A class with a class method stubbed" do
  
  before do
    Time.stub_method(:now => 42)
  end
  
  it "should return the stubbed result" do
    Time.now.should == 42
  end
  
  it "should return the original result after stubbing is removed" do
    Time.remove_logging_and_stubbing
    Time.now.should_not == 42
  end
  
  it "should return the original result after all stubbing is removed" do
    Object.remove_all_logging_and_stubbing
    Time.now.should_not == 42
  end

end

describe "An object with a boolean instance method stubbed" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:is_great? => true)
  end
  
  it "should return the stubbed result" do
    @object.is_great?.should be_true
  end

end
