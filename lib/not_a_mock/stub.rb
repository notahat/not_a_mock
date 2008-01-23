module NotAMock
  
  class Stub
    
    def initialize(object_name, methods = {})
      @name     = object_name.to_s
      @call_log = []
      @methods  = methods
    end
    
    attr_reader :call_log
    
    def inspect
      "Stub #{@name}"
    end
  
    def method_missing(method, *args)
      if @methods.has_key?(method)
        @call_log << {
          :method => method,
          :args   => args,
          :result => @methods[method]
        }
        @methods[method]
      else
        raise NoMethodError.new("Undefined method #{method} called on #{inspect}")
      end
    end
    
    def id(*args)
      method_missing(:id, *args)
    end
    
  end # class Stub
  
end # module NotAMock
