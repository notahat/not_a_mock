module ActiveRecord # :nodoc:
  class Base
    
    def self.stub_instance(methods = {})
      @@__stub_object_id ||= 1000
      @@__stub_object_id += 1
      methods = methods.merge(:id => @@__stub_object_id)
      NotAMock::Stub.new(self, methods)
    end
    
  end
end
