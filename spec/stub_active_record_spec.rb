# $Id: stub_active_record_spec.rb 986 2007-05-09 07:48:34Z pete $
# vim: ts=2 sw=2 ai expandtab

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'not_a_mock'

class ExampleActiveRecord < ActiveRecord::Base
end

describe ActiveRecord::Base, " when stubbed" do
  
  before do
    @example = ExampleActiveRecord.stub_instance
  end
  
  it "should support the id method" do
    lambda { @example.id }.should_not raise_error(NoMethodError)
    @example.id.should be_an_instance_of(Fixnum)
  end
  
end
