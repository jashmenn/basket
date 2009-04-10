$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'
def log(*args); p args; end


# want to be able to process in parallel
Basket.process("orders", :workers => 4) do |file|
  log $$, :processing, file
end

