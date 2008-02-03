module NotAMock
  module RspecMockFrameworkAdapter
    
    def setup_mocks_for_rspec
    end
    
    def verify_mocks_for_rspec
    end
    
    def teardown_mocks_for_rspec
      NotAMock::CallRecorder.instance.reset
      NotAMock::Stubber.instance.reset
    end
    
  end
end
