class Object
  
  # Call this on any object or class with a list of method names. Any future
  # calls to those methods will be recorded in NotAMock::CallRecorder.
  #
  # See NotAMock::Matchers for info on how to test which methods have been
  # called, with what arguments, etc.
  def track_methods(*methods)
    methods.each do |method|
      NotAMock::CallRecorder.instance.track_method(self, method)
    end
  end
  alias_method(:track_method, :track_methods)
  alias_method(:log_calls_to, :track_methods)  # For backwards compatibility.
  
  # Stop recording calls for the given methods.
  def untrack_methods(*methods)
    methods.each do |method|
      NotAMock::CallRecorder.instance.untrack_method(self, method)
    end
  end
  alias_method(:untrack_method, :untrack_methods)
  
  # If passed a symbol and a block, this replaces the named method on this
  # object with a stub version that evaluates the block and returns the result.
  #
  # If passed a hash, this is an alias for stub_methods.
  def stub_method(method, &block)
    case method
      when Symbol
        NotAMock::CallRecorder.instance.untrack_method(self, method)
        NotAMock::Stubber.instance.unstub_method(self, method)
        NotAMock::Stubber.instance.stub_method(self, method, &block)
        NotAMock::CallRecorder.instance.track_method(self, method)
      when Hash
        stub_methods(method)
      else
        raise ArgumentError
    end
  end
  
  # Takes a hash of method names mapped to results, and replaces each named
  # method on this object with a stub version returning the corresponding result.
  #
  # Calls to stubbed methods are recorded in the NotAMock::CallRecorder,
  # so you can later make assertions about them as described in
  # NotAMock::Matchers.
  def stub_methods(methods, &block)
    methods.each do |method, result|
      stub_method(method) {|*args| result }
    end
  end
  
  # Takes a hash of method names mapped to exceptions, and replaces each named
  # method on this object with a stub version returning the corresponding exception.
  def stub_methods_to_raise(methods)
    methods.each do |method, exception|
      stub_method(method) {|*args| raise exception }
    end
  end
  alias_method(:stub_method_to_raise, :stub_methods_to_raise)
  
  # Removes the stubbed versions of the given methods and restores the
  # original methods.
  def unstub_methods(*methods)
    methods.each do |method, result|
      NotAMock::CallRecorder.instance.untrack_method(self, method)
      NotAMock::Stubber.instance.unstub_method(self, method)
    end
  end
  alias_method(:unstub_method, :unstub_methods)
  
  class << self
    # Called on a class, creates a stub instance of that class. Takes a hash of
    # method names and their returns values, and creates those methods on the new
    # stub instance.
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
