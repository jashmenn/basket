$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'
def log(*args); p args; end

# baskets:
#  * inbox
#  * pending
#  * success
#  * fail
Basket.process("orders", :conditional => true) do |file|
  log :processing, file
  if file =~ /cat/
    log :success, file
    true # block returns true for success
  else
    log :fail, file
    false
  end
end

