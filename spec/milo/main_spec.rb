# encoding: utf-8
require "milo"

describe Milo::Main do
  before(:each) do
    @key = "ffbefff2a246f4c53c0d04ed50bb4707"
    @milo = Milo::Main.new(@key)
  end

  describe "basic" do
    it "should have the correct mail_url" do
      @milo.main_url.should == "https://api.x.com/milo/v3/"
    end
  end

  describe 'make_request' do
    context "product" do
      it "should construct url for product" do
        response = @milo.make_request("products?product_ids=1234")
      end
    end
  end
end
