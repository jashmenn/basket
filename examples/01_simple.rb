$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'
def log(*args); p args; end

# Default baskets: inbox, pending, archive
Basket.process("orders") do |file|
  log :processing, file
end
