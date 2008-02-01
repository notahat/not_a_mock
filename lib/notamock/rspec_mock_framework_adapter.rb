module Notamock
  module RspecMockFrameworkAdapter
    
    def setup_mocks_for_rspec
    end
    
    def verify_mocks_for_rspec
    end
    
    def teardown_mocks_for_rspec
      Notamock::CallRecorder.instance.reset
      Notamock::Stubber.instance.reset
    end
    
  end
end
