module Basket
  VERSION = '0.0.1'

  DIR = File.expand_path(File.dirname(File.expand_path(__FILE__)))
  $:.unshift DIR

  require 'fileutils'
  require 'pp'
  require 'ext/core'
  require 'ext/metaid'
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

    # Process a directory of files. Move them to a new location. 
    #
    # Options:
    #  * :inbox
    #  * :pending
    #  * :archive
    #  * :other
    #  * :logdev
    #  * :conditional
    def initialize(root, opts={})
      @root = root
      @inbox   = opts.delete(:inbox)   || INBOX
      @pending = opts.delete(:pending) || PENDING
      @archive = opts.delete(:archive) || ARCHIVE
      @other   = opts.delete(:other)   || []
      @logdev  = opts.delete(:logdev)
      @opts    = opts
    end

    # block arity
    def process(&block)
      create_directories 
      files = Dir[@root/@inbox/"*"]
      logger.debug(["#{files.size} files in", @root/@inbox/"*"])
      files.each_with_index do |file, i|
        pending_file = @root/@pending/File.basename(file)

        logger.info [:mv, file, pending_file]
        mv file, pending_file

        to_mix = mixin
        pending_file.meta_eval { include to_mix }

        result = block.arity > 1 ? block.call(pending_file, i) : block.call(pending_file)

        if @opts[:conditional]
          destination = result ? @root/"success" : @root/"fail"
          logger.info [:mv, pending_file, destination]
          mv pending_file, destination
        elsif @opts[:other]
          # don't mv anything
        else
          logger.info [:mv, pending_file, @root/@archive]
          mv pending_file, @root/@archive
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

    def mixin
      # create local definitions for closures 
      our_baskets = baskets
      our_root    = @root
      our_logger  = logger
      @mixin ||= begin 
        movingMethods = Module.new
        movingMethods.module_eval do
          our_baskets.each do |basket|
            define_method "#{basket}!" do
              puts "calling #{basket}!"
              our_logger.info [:mv, self, our_root/basket]
              FileUtils.mv self, our_root/basket
            end
          end
        end
        movingMethods
      end
    end

    def baskets
      baskets = [@inbox, @pending, @archive, @other]
      baskets << ["success", "fail"] if @opts[:conditional]
      baskets.flatten.compact
    end

  end
end

