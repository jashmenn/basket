require File.dirname(__FILE__) + '/spec_helper'

def log *args
  return false # comment to log these tests to stdout
  p args
end

describe "Basket" do
  include BasketFixtures

  before(:each) do
    create_fixture_files
    @root = FIXTURES_DIR/"orders"
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

  describe "basic usage"  do
    it "should process files" do
      Dir["#{@root}/inbox/*"].size.should == 25 # check and make sure files are in the inbox

      Basket.process(@root, :logdev => "/dev/null") do |file|
        log :processing, file
      end

      Dir["#{@root}/inbox/*"  ].size.should == 0 
      Dir["#{@root}/archive/*"].size.should == 25
    end
  end

  describe "conditional usage" do
    it "should process files" do
      Dir["#{@root}/inbox/*"].size.should == 25 # check and make sure files are in the inbox

      Basket.process(@root, :conditional => true, :logdev => "/dev/null") do |file, i|
        if i % 2 == 0
          log :success, file
          true 
        else
          log :fail, file
          false
        end
      end

      Dir["#{@root}/inbox/*"   ].size.should == 0 
      Dir["#{@root}/success/*" ].size.should == 13 
      Dir["#{@root}/fail/*"    ].size.should == 12 
    end
  end

  describe "custom baskets" do
    it "should process files" do
      create_fixture_files("new")
      Dir["#{@root}/new/*"].size.should == 25 # check and make sure files are in the inbox

      Basket.process(@root, :inbox => "new", :pending => "work", :other => %w{good bad unknown}) do |file, i|
        case i % 3 
        when 0 
          log :good, file
          file.good!
        when 1
          log :bad, file
          file.bad!
        when 2
          log :unknown, file
          file.unknown!
        end
      end

      Dir["#{@root}/new/*"     ].size.should == 0
      Dir["#{@root}/good/*"    ].size.should == 9
      Dir["#{@root}/bad/*"     ].size.should == 8
      Dir["#{@root}/unknown/*" ].size.should == 8
    end
  end

  describe "parallel processing with forkoff" do
    it "should process the files" do
      create_fixture_files("inbox", 10)
      Basket.process(@root, :workers => 2) do |file, i|
        log $$, :processing, file, i
      end
    end
  end

  after(:each) do
    cleanup_fixtures_dir
  end
end