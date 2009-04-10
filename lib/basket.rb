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
  
  # == Basket
  # Process a directory of files, one at a time.
  #
  # == Overview
  # Take +root+ folder and look for the directory +inbox+. Each file in
  # +inbox+ is first +mv+'d to +pending+ and then yielded to +block+. Upon
  # completion of the block the file is +mv+'d to a directory, as specifed in
  # the options.
  #
  # == Options
  # * <tt>:inbox</tt>: the name of the inbox folder (default +inbox+)
  # * <tt>:pending</tt>: the name of the pending folder (default +pending+)
  # * <tt>:archive</tt>: the name of the archive folder (default +archive+)
  # * <tt>:other</tt>: if +other+ is specified then the files are *not* moved to the archive or any other directory automatically. You *must* specify where the file will go or it will remain in +inbox+. incompatable with +conditional+.
  # * <tt>:logdev</tt>: device to log to. For example: <tt>STDOUT</tt> or <tt>"/path/to/log.log"</tt> (default: <tt>/dev/null</tt>)
  # * <tt>:conditional</tt>: if +conditional+ is specified then then the result of the #process block is interpreted as boolean. if the result is +true+ then the file is mv'd to +success+ otherwise it is mv'd to +fail+
  #
  # == Block Arity
  # If the block takes a single argument, then a string containing the path to
  # the +pending+ file is yielded. If the block accepts two arugments then the
  # file index is also yielded
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
      @logdev  = opts.delete(:logdev)  || "/dev/null"
      @opts    = opts
    end

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
        elsif @other.size > 0
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

    # create the Module that will be mixed in to the String representing the
    # files this allows us to define exclamation methods that will move the
    # files to a particular directory
    def mixin # :nodoc:
      our_baskets, our_root, our_logger = baskets, @root, logger # create local definitions for closures 
      @mixin ||= begin 
        movingMethods = Module.new
        movingMethods.module_eval do
          our_baskets.each do |basket|
            define_method "#{basket}!" do
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

