require 'singleton'
require 'notamock/object_extensions'

module Notamock
  # The CallRecorder is a singleton that keeps track of all the call
  # recording hooks installed, and keeps a central record of calls.
  class CallRecorder
    include Singleton
  
    def initialize
      @calls = []
      @tracked_methods = []
    end
  
    # An array of recorded calls in chronological order.
    #
    # Each call is represented by a hash, in this format:
    #   { :object => example_object, :method => :example_method, :args => ["example argument"], :result => "example result" }
    attr_reader :calls
    
    # Return an array of all the calls made to any method of +object+, in chronological order.
    def calls_by_object(object)
      @calls.select {|call| call[:object] == object }
    end
    
    # Return an array of all the calls made to +method+ of +object+, in chronological order.
    def calls_by_object_and_method(object, method)
      @calls.select {|call| call[:object] == object && call[:method] == method }
    end
  
    # Patch +object+ so that future calls to +method+ will be recorded.
    #
    # You should call Object#track_methods rather than calling this directly.
    def track_method(object, method)
      unless @tracked_methods.include?([object, method])
        @tracked_methods << [object, method]
        add_hook(object, method)
      end
    end
  
    # Remove the patch from +object+ so that future calls to +method+
    # will not be recorded.
    #
    # You should call Object#track_methods rather than calling this directly.
    def untrack_method(object, method)
      if @tracked_methods.delete([object, method])
        remove_hook(object, method)
      end
    end
    
    # Stop recording all calls.
    def untrack_all
      @tracked_methods.each do |object, method|
        remove_hook(object, method) 
      end
      @tracked_methods = []
    end
    
    # Remove all patches so that calls are no longer recorded, and clear the call log.
    def reset
      untrack_all
      @calls = []
    end

  private

    def add_hook(object, method)
      object.meta_eval do
        alias_method("__unlogged_#{method}", method)
        define_method(method) {|*args| CallRecorder.instance.send(:record_and_send, self, method, args) }
      end
    end

    def record_and_send(object, method, args)
      result = object.send("__unlogged_#{method}", *args)
      @calls << { :object => object, :method => method, :args => args, :result => result }
      result
    end
  
    def remove_hook(object, method)
      object.meta_eval do
        alias_method(method, "__unlogged_#{method}")
        remove_method("__unlogged_#{method}")
      end
    end

  end
end
