module NotAMock
  module RspecMockFrameworkAdapter
    
    def setup_mocks_for_rspec
    end
    
    def verify_mocks_for_rspec
    end
    
    def teardown_mocks_for_rspec
      Object.remove_all_logging_and_stubbing
    end
    
  end
end
