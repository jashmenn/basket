# Module for easy logging in Ruby
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
module HasLogger
  def self.included(mod)
    mod.extend(ClassMethods)
    mod.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods

    # def log *args
    #   return unless @settings[:logging] or amqp.logging
    #   require 'pp'
    #   pp args
    #   puts
    # end

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
