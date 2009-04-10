module Basket
  VERSION = '0.0.1'

  DIR = File.expand_path(File.dirname(File.expand_path(__FILE__)))
  $:.unshift DIR

  require 'fileutils'
  require 'pp'
  require 'ext/core'
  require 'has_logger'

  class << self
    @logging = false
    attr_accessor :logging
  end
  
  def self.process(input, opts={}, &block)
    b = Base.new(input, opts)
    b.process(&block)
  end

  class Base

    INBOX   = "inbox"
    PENDING = "pending"
    ARCHIVE = "archive"

    attr_accessor :root
    attr_accessor :inbox
    attr_accessor :pending
    attr_accessor :other

    include HasLogger
    include FileUtils

    def initialize(root, opts={})
      @root = root
      @inbox   = opts.delete(:inbox)   || INBOX
      @pending = opts.delete(:pending) || PENDING
      @archive = opts.delete(:archive) || ARCHIVE
      @other   = opts.delete(:other)   || []
      @logdev  = opts.delete(:logdev)
      @opts    = opts
    end

    def process(&block)
      files = Dir[@root/@inbox/"*"]
      logger.debug(["#{files.size} files in", @root/@inbox/"*"])
      files.each do |file|
        mv(file, @root/@pending)
        result = block.call(file)
        if @opts[:conditional]
          puts "todo"
        else
          logger.info [:mv, @root/@pending/File.basename(file), @root/@archive]
          mv(@root/@pending/File.basename(file), @root/@archive)
        end
      end
    end

    protected
    def create_directories
      baskets.each do |dir|
        logger.debug([:creating, @root/dir])
        mkdir_p(@root/dir)
      end
    end

    def baskets
      [@inbox, @pending, @archive, @other].flatten.compact
    end

  end
end

