$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'notamock'

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
  
  after do
    Notamock::CallRecorder.instance.reset
    Notamock::Stubber.instance.reset
  end
  
end
