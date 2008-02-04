$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

class ExampleActiveRecord < ActiveRecord::Base
end

describe "A stubbed ActiveRecord object" do
  
  before do
    @example = ExampleActiveRecord.stub_instance
  end
  
  it "should return a valid id" do
    lambda { @example.id }.should_not raise_error(NoMethodError)
    @example.id.should be_an_instance_of(Fixnum)
  end
  
  it "should return the id for to_param" do
    lambda { @example.to_param }.should_not raise_error(NoMethodError)
    @example.to_param.should be_an_instance_of(Fixnum)
  end
  
  after do
    NotAMock::CallRecorder.instance.reset
    NotAMock::Stubber.instance.reset
  end
  
end
