$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'
def log(*args); p args; end

Basket.process("orders", :conditional => true, :logdev => "/dev/null") do |file, i|
  if i % 2 == 0
    log :success, file
    true # returning true mv's file to +success+
  else
    log :fail, file
    false # returning false mv's file to +faile+
  end
end
