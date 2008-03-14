module NotAMock
  # Instances returned by Object.stub_instance are NotAMock::Stub objects.
  # These do their best to masquerade as the real thing.
  class Stub
    
    # This is normall only called from Object.stub_instance.
    def initialize(stubbed_class, methods = {}) #:nodoc:
      @stubbed_class = stubbed_class
      methods.each do |method, result|
        self.meta_eval do
          define_method(method) { result }
        end
        track_method(method)
      end
    end
    
    # Returns "Stub StubbedClass".
    def inspect
      "Stub #{@stubbed_class.to_s}"
    end
  
    # Returns true if the class of the stubbed object or one of its superclasses is klass. 
    def is_a?(klass)
      @stubbed_class.ancestors.include?(klass)
    end
    
    alias_method :kind_of?, :is_a?
    
    # Returns true if the class of the stubbed object is klass.
    def instance_of?(klass)
      @stubbed_class == klass
    end
    
    # Returns the class of the stubbed object.
    def class
      @stubbed_class
    end

  end
end
