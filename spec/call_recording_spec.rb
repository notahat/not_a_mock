$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'notamock'

class TrackedClass
  def my_method(argument)
    "result"
  end
end

describe "A recorded method" do
  
  before do
    @recorder = Notamock::CallRecorder.instance
    @object = TrackedClass.new
    @object.track_method(:my_method)
  end
  
  it "should record a method call" do
    @object.my_method("argument")
    
    @recorder.calls.should include(:object => @object, :method => :my_method, :args => ["argument"], :result => "result")
  end
  
  it "should not record calls after untrack_method" do
    @object.my_method("argument 1")
    @object.untrack_method(:my_method)
    @object.my_method("argument 2")
    
    @recorder.calls.should include(:object => @object, :method => :my_method, :args => ["argument 1"], :result => "result")
    @recorder.calls.should_not include(:object => @object, :method => :my_method, :args => ["argument 2"], :result => "result")
  end
  
  it "should not record calls after stop_all_recording" do
    @object.track_method(:my_method)
    @object.my_method("argument 1")
    @recorder.untrack_all
    @object.my_method("argument 2")
    
    @recorder.calls.should include(:object => @object, :method => :my_method, :args => ["argument 1"], :result => "result")
    @recorder.calls.should_not include(:object => @object, :method => :my_method, :args => ["argument 2"], :result => "result")
  end
  
  it "should not break when track_method is called again" do
    @object.track_method(:my_method)
    @object.my_method("argument 1")
    @object.untrack_method(:my_method)
    @object.my_method("argument 2")
    
    @recorder.calls.should include(:object => @object, :method => :my_method, :args => ["argument 1"], :result => "result")
    @recorder.calls.should_not include(:object => @object, :method => :my_method, :args => ["argument 2"], :result => "result")
  end
  
  it "should not break when untrack_method is called more than once" do
    @object.track_method(:my_method)
    @object.my_method("argument 1")
    @object.untrack_method(:my_method)
    @object.untrack_method(:my_method)
    @object.my_method("argument 2")
    
    @recorder.calls.should include(:object => @object, :method => :my_method, :args => ["argument 1"], :result => "result")
    @recorder.calls.should_not include(:object => @object, :method => :my_method, :args => ["argument 2"], :result => "result")
  end
  
  after do
    @recorder.reset
  end
  
end
