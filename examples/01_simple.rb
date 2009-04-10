$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'
def log(*args); p args; end

# default baskets:
#  * inbox
#  * pending
#  * archive

# in this case starts in inbox,
# mv'd to pending, processed, then mvd to archive
Basket.process("orders") do |file|
  log :processing, file
end

