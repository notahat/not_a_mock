class Object
  
  # FIXME: Write docs!
  def track_methods(*methods)
    methods.each do |method|
      NotAMock::CallRecorder.instance.track_method(self, method)
    end
  end
  alias_method(:track_method, :track_methods)
  alias_method(:log_calls_to, :track_methods)  # For backwards compatibility.
  
  # FIXME: Write docs!
  def untrack_methods(*methods)
    methods.each do |method|
      NotAMock::CallRecorder.instance.untrack_method(self, method)
    end
  end
  alias_method(:untrack_method, :untrack_methods)
  
  # FIXME: Write docs!
  def stub_methods(methods)
    methods.each do |method, result|
      NotAMock::CallRecorder.instance.untrack_method(self, method)
      NotAMock::Stubber.instance.unstub_method(self, method)
      NotAMock::Stubber.instance.stub_method(self, method, result)
      NotAMock::CallRecorder.instance.track_method(self, method)
    end
  end
  alias_method(:stub_method, :stub_methods)
  
  # FIXME: Write docs!
  def unstub_methods(*methods)
    methods.each do |method, result|
      NotAMock::CallRecorder.instance.untrack_method(self, method)
      NotAMock::Stubber.instance.unstub_method(self, method)
    end
  end
  alias_method(:unstub_method, :unstub_methods)
  
  class << self
    # FIXME: Write docs!
    # FIXME: Should this be a method on Class?
    def stub_instance(methods = {})
      NotAMock::Stub.new(self, methods)
    end
  end
  
  # Returns the metaclass of this object. For an explanation of metaclasses, see:
  # http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
  def metaclass
    class << self
      self
    end
  end
  
  # Evaluates the block in the context of this object's metaclass.
  def meta_eval(&block)
    metaclass.instance_eval(&block)
  end
  
end
