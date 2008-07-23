require 'singleton'
require 'not_a_mock/object_extensions'

module NotAMock
  # The Stubber is a singleton that keeps track of all the stub methods
  # installed in any object.
  class Stubber
    include Singleton
  
    def initialize
      @stubbed_methods = []
    end
  
    # Stub +method+ on +object+ to evalutate +block+ and return the result.
    # 
    # You should call Object#stub_method rathing than calling this directly.
    def stub_method(object, method, &block) #:nodoc:
      unless @stubbed_methods.include?([object, method])
        @stubbed_methods << [object, method]
        add_hook(object, method, &block)
      end
    end
        
    # Remove the stubbed +method+ on +object+.
    #
    # You should call Object#unstub_methods rather than calling this directly.
    def unstub_method(object, method) #:nodoc:
      if @stubbed_methods.delete([object, method])
        remove_hook(object, method)
      end
    end
  
    # Removes all stub methods.
    def reset
      @stubbed_methods.each do |object, method|
        remove_hook(object, method) 
      end
      @stubbed_methods = []
    end
    
  private

    def add_hook(object, method, &block)
      method_exists = method_at_any_level?(object, method.to_s)
      object.meta_eval do
        alias_method("__unstubbed_#{method}", method) if method_exists
        define_method(method, &block)
      end
    end
  
    def remove_hook(object, method)
      method_exists = method_at_any_level?(object, "__unstubbed_#{method}")
      object.meta_eval do
        if method_exists
          alias_method(method, "__unstubbed_#{method}")
          remove_method("__unstubbed_#{method}")
        else
          remove_method(method)
        end
      end
    end
    
    def method_at_any_level?(object, method)
      object.methods.include?(method) ||
      object.protected_methods.include?(method) ||
      object.private_methods.include?(method)
    end
  end
end
