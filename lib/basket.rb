module Basket
  VERSION = '0.0.1'

  DIR = File.expand_path(File.dirname(File.expand_path(__FILE__)))
  $:.unshift DIR

  require 'fileutils'
  require 'pp'
  require 'ext/core'

  class << self
    @logging = false
    attr_accessor :logging
  end
  
  def self.process(input, opts={}, &block)

  end

  class Base

    INBOX   = "inbox"
    PENDING = "pending"
    ARCHIVE = "archive"
    DEFAULT_BASKETS = [ INBOX, PENDING, ARCHIVE ]

    attr_accessor :root
    attr_accessor :inbox
    attr_accessor :pending
    attr_accessor :baskets

    def initialize(root, opts={})
      @root = root
      @inbox   = opts[:inbox]   || INBOX
      @pending = opts[:pending] || PENDING
      @archive = opts[:archive] || ARCHIVE
      @baskets = opts[:baskets] || DEFAULT_BASKETS
    end

    def process(&block)
    end

    protected
    def create_directories
      p "creating"
      p baskets
      baskets.flatten.compact.each do |dir|
        puts "making #{@root/dir}"
        FileUtils.mkdir_p(@root/dir)
      end
    end

  end
end

