$:.unshift File.dirname(__FILE__) + "/../lib"
require 'basket'

def log *args
  p args
end

# default baskets:
#  * inbox
#  * pending
#  * archive

# in this case starts in inbox,
# mv'd to pending, processed, then mvd to archive
Basket.process("orders") do |file|
  log :processing, file
end

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

# baskets:
#   * new (inbox)
#   * work (pending)
#   * good
#   * bad
#   * unknown
Basket.process("orders", :inbox => "new", :pending => "work", :other_baskets => %w{good bad unknown}) do |file|
  log :processing, file

  if file =~ /cat/
    log :good, file
    file.good!
  else if file =~ /dog/
    log :bad, file
    file.bad!
  else
    log :bad, file
    file.unknown!
  end

end

# want to be able to process in parallel
Basket.process("orders", :workers => 4) do |file|
  log $$, :processing, file
end

