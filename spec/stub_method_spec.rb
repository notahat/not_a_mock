$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'notamock'

describe "A stubbed method replacing an existing instance method" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:length => 42)
  end
  
  it "should return the stubbed result" do
    @object.length.should == 42
  end
  
  it "should return the original result after stubbing is removed" do
    @object.unstub_method(:length)
    @object.length.should == 13
  end
  
  it "should return the original result after a reset" do
    Notamock::Stubber.instance.reset
    @object.length.should == 13
  end
  
  it "should return the new result if re-stubbed" do
    @object.stub_method(:length => 24)
    @object.length.should == 24
  end
  
  it "should record a call to the stubbed method" do
    @object.length
    Notamock::CallRecorder.instance.calls.should include(:object => @object, :method => :length, :args => [], :result => 42)
  end
  
  it "should return a call to the stubbed method if re-stubbed" do
    @object.stub_method(:length => 24)
    @object.length
    Notamock::CallRecorder.instance.calls.should include(:object => @object, :method => :length, :args => [], :result => 24)
  end
  
  after do
    Notamock::CallRecorder.instance.reset
    Notamock::Stubber.instance.reset
  end

end

describe "A stubbed method with no existing instance method" do
  
  before do
    @object = "Hello, world!"
    @object.stub_method(:blah => 42)
  end
  
  it "should return the stubbed result" do
    @object.blah.should == 42
  end
  
  it "should raise a NoMethodError when the method is called after stubbing is removed" do
    @object.unstub_method(:blah)
    lambda { @object.blah }.should raise_error(NoMethodError)
  end
  
  it "should raise a NoMethodError when the method is called after all stubbing is removed" do
    Notamock::Stubber.instance.reset
    lambda { @object.blah }.should raise_error(NoMethodError)
  end
  
  it "should record a call to the stubbed method" do
    @object.blah
    Notamock::CallRecorder.instance.calls.should include(:object => @object, :method => :blah, :args => [], :result => 42)
  end
  
  after do
    Notamock::CallRecorder.instance.reset
    Notamock::Stubber.instance.reset
  end
  
end

describe "A stubbed class method" do
  
  before do
    Time.stub_method(:now => 42)
  end
  
  it "should return the stubbed result" do
    Time.now.should == 42
  end
  
  it "should return the original result after stubbing is removed" do
    Time.unstub_method(:now)
    Time.now.should_not == 42
  end
  
  it "should return the original result after a reset" do
    Notamock::Stubber.instance.reset
    Time.now.should_not == 42
  end

  after do
    Notamock::CallRecorder.instance.reset
    Notamock::Stubber.instance.reset
  end
  
end

describe "Object#stub_method" do
  
  it "should stub a method with a name ending in '?'" do
    @object = "Hello, world!"
    @object.stub_method(:is_great? => true)
    @object.is_great?.should be_true
  end
  
  it "should stub the []= method" do
    @object = Array.new
    @object.stub_method(:[]= => nil)
    @object[0] = 7
    @object.length.should == 0
  end

  after do
    Notamock::CallRecorder.instance.reset
    Notamock::Stubber.instance.reset
  end
  
end
