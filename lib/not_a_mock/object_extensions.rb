require 'set'

class Object

  def self.stub_instance(methods = {})
    NotAMock::Stub.new(self, methods)
  end
  
  def log_calls_to(*methods)
    __setup_call_logging
    methods.each do |method|
      unless @__logged_methods.include?(method)
        @__logged_methods << method
        instance_eval <<-EOF
          def __logged_#{method}(*args); __send_with_logging(:#{method}, args); end
          alias __unlogged_#{method} #{method} if defined?(#{method})
          alias #{method} __logged_#{method}
        EOF
      end
    end
  end
  
  def call_log
    @__call_log || []
  end
    
  def stub_methods(methods)
    methods.each_pair do |method, result|
      log_calls_to(method)
      @__method_stubs[method]  = result
    end
  end
  
  def stub_method(method)
    stub_methods(method)
  end
  
  def remove_logging_and_stubbing
    unless @__logged_methods.nil?
      @__logged_methods.each do |method|
        instance_eval <<-EOF
          if defined?(__unlogged_#{method})
            alias #{method} __unlogged_#{method}
          else
            undef #{method}
          end
          undef __logged_#{method}
        EOF
      end
      remove_instance_variable :@__logged_methods
      remove_instance_variable :@__call_log
      remove_instance_variable :@__method_stubs
      @@__logged_objects.delete_if {|object| object.equal?(self) }
    end
  end
  
  def self.remove_all_logging_and_stubbing
    return unless defined?(@@__logged_objects)
    # We're deleting objects from the array as we iterate,
    # hence the clone to make sure it's safe.
    @@__logged_objects.clone.each do |object|
      object.remove_logging_and_stubbing
    end
  end
  
private

  def __setup_call_logging
    @__logged_methods ||= Set.new
    @__call_log       ||= []
    @__method_stubs   ||= {}
    
    @@__logged_objects ||= []
    @@__logged_objects << self unless @@__logged_objects.find {|object| object.equal?(self) }
  end

  def __send_with_logging(method, args)
    result = @__method_stubs.has_key?(method) ? @__method_stubs[method] : send("__unlogged_#{method}".to_sym, *args)
    @__call_log << {
      :method => method,
      :args   => args,
      :result => result
    }
    result
  end

end
