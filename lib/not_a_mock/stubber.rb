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
  
    # Stub +method+ on +object+ to return +result+.
    #
    # You should call Object#stub_methods rather than calling this directly.
    def stub_method(object, method, result)
      unless @stubbed_methods.include?([object, method])
        @stubbed_methods << [object, method]
        add_hook(object, method, result)
      end
    end
  
    # Remove the stubbed +method+ on +object+.
    #
    # You should call Object#unstub_methods rather than calling this directly.
    def unstub_method(object, method)
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

    def add_hook(object, method, result)
      object.meta_eval do
        alias_method("__unstubbed_#{method}", method) if object.methods.include?(method.to_s)
        define_method(method) {|*args| result }
      end
    end
  
    def remove_hook(object, method)
      object.meta_eval do
        if object.methods.include?("__unstubbed_#{method}")
          alias_method(method, "__unstubbed_#{method}")
          remove_method("__unstubbed_#{method}")
        else
          remove_method(method)
        end
      end
    end
  
  end
end
