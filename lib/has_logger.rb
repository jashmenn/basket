# Module for easy logging
#
# Example:
#  
#   class MyClass
#      include HasLogger
#
#      # ...
#      def do_something
#        logger.info("I just did something!")
#      end
#   end
require 'logger'

module HasLogger
  def self.included(mod)
    mod.extend(ClassMethods)
    mod.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def logger
      @logger ||= begin 
                logger = Logger.new(@logdev || STDOUT)
                logger.formatter = Logger::Formatter.new
                logger.datetime_format = "%Y-%m-%d %H:%M:%S"
                logger
              end
    end
  end
end
