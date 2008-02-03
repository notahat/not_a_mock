module NotAMock
  # Instances returned by Object.stub_instance are NotAMock::Stub objects.
  class Stub
    
    def initialize(object_name, methods = {})
      @name = object_name.to_s
      methods.each do |method, result|
        self.meta_eval do
          define_method(method) { result }
        end
        track_method(method)
      end
    end
    
    def inspect
      "Stub #{@name}"
    end
  
  end
end
