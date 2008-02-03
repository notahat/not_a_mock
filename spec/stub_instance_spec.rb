$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

describe "A stub instance" do
  
  before do
    @object = String.stub_instance(:length => 42, :id => 99)
  end
  
  it "should return the right result for a stubbed method" do
    @object.length.should == 42
  end
  
  it "should return its name when inspected" do
    @object.inspect.should == "Stub String"
  end
  
  it "should handle the id method being stubbed" do
    @object.id.should == 99
  end
  
  it "should raise an error when a method that's not stubbed is called" do
    lambda { @object.whatever }.should raise_error(NoMethodError)
  end
  
  it "should record a call to a stubbed method" do
    @object.length
    NotAMock::CallRecorder.instance.calls.should include(:object => @object, :method => :length, :args => [], :result => 42)
  end
  
  it "should allow adding of new stubbed methods" do
    @object.stub_method(:width => 7)
    @object.width.should == 7
  end
  
  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end 
  
end
