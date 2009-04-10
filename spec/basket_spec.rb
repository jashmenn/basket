require File.dirname(__FILE__) + '/spec_helper'

describe "Basket" do
  include BasketFixtures

  before(:each) do
    create_fixture_files
  end

  describe "Basket::Base" do 
    describe "using default options" do
      before(:each) do
        @b = Basket::Base.new(FIXTURES_DIR/"orders", :logdev => "/dev/null")
      end

      it "should have root" do
        @b.root.should eql(FIXTURES_DIR/"orders")
      end

      it "should create the needed directories" do
        %w{pending archive}.each { |basket| File.exists?(@b.root/basket).should be_false }
        @b.send(:create_directories)
        %w{pending archive}.each { |basket| File.exists?(@b.root/basket).should be_true }
      end
    end

    describe "making custom directories" do
      before(:each) do
        @all = %w{new work done foo bar baz}
        @b = Basket::Base.new(FIXTURES_DIR/"orders", :inbox   => "new", 
                                                     :pending => "work", 
                                                     :archive => "done",
                                                     :other   => @all,
                                                     :logdev => "/dev/null")
      end

      it "should create them" do
        @all.each { |basket| File.exists?(@b.root/basket).should be_false }
        @b.send(:create_directories)
        @all.each { |basket| File.exists?(@b.root/basket).should be_true }
      end
    end
  end

  describe("basic usage") do
    it "should process files" do
      # check and make sure files are in the inbox
      Basket.process("orders") do |file|
        log :processing, file
      end
      # check and make sure the files are not in the inbox
      # make sure files are in archive
    end
  end

  after(:each) do
    # cleanup_fixtures_dir
  end
end