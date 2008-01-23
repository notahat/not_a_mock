# $Id: stub_object_spec.rb 994 2007-05-17 07:57:56Z pete $
# vim: ts=2 sw=2 ai expandtab

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

# FIXME: Make sure stubbed methods also have calls logged.

describe NotAMock::Stub do
  
  before do
    @object = NotAMock::Stub.new('Example', :length => 42, :id => 99)
  end
  
  it "should return the right result for a stubbed method" do
    @object.length.should == 42
  end
  
  it "should return its name when inspected" do
    @object.inspect.should == 'Stub Example'
  end
  
  it "should handle the id method being stubbed" do
    @object.id.should == 99
  end
  
  it "should raise an error on a method that's not stubbed" do
    lambda { @object.whatever }.should raise_error(NoMethodError)
  end
  
end

describe NotAMock::Stub, " created by stubbing an existing class" do
 
  before do
    @object = String.stub_instance(:length => 42)
  end
  
  it "should return the right result for a stubbed method" do
    @object.length.should == 42
  end

end
