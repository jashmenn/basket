require File.dirname(__FILE__) + '/spec_helper'

describe "Basket" do
  include BasketFixtures

  before(:each) do
    create_fixture_files
  end

  describe "Basket::Base" do 
    describe "using default options" do
      before(:each) do
        @b = Basket::Base.new(FIXTURES_DIR/"orders")
      end

      it "should have root" do
        @b.root.should eql(FIXTURES_DIR/"orders")
      end

      it "should create the needed directories" do
        r = @b.root
        %w{pending archive}.each { |basket| File.exists?(r/basket).should be_false }
        @b.send(:create_directories)
        %w{pending archive}.each { |basket| File.exists?(r/basket).should be_true }
      end

    end
  end

  describe("basic usage") do
    it "process files" do
      Basket.process("orders") do |file|
        log :processing, file
      end
    end
  end

  after(:each) do
    # cleanup_fixtures_dir
  end
end