$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'
def log(*args); p args; end

Basket.process("orders", :inbox => "new", :pending => "work", :other => %w{good bad unknown}) do |file, i|
  case i % 3 
  when 0 
    log :good, file
    file.good! # mv's file to "orders/good"
  when 1
    log :bad, file
    file.bad!
  when 2
    log :unknown, file
    file.unknown!
  end
end
