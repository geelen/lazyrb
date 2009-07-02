# Created by IntelliJ IDEA.
# User: glen
# Date: 02/07/2009
# Time: 1:20:06 PM
# To change this template use File | Settings | File Templates.

numbers = %w{1.3 1.5 1.8}

puts "# 1 - standard stuff"
p numbers.map { |x| x.to_f }

puts "# 2 - passing in a proc using &"
to_f_proc = proc { |x| x.to_f }
p numbers.map(&to_f_proc)

puts "# 3 - passing in a dynamic proc"
def hax_proc method
  proc { |x| x.send(method) }
end
p numbers.map(&hax_proc(:to_f))

puts "# 4 - ruby calls to_proc on what's passed in as the block"
class ToF
  def to_proc
    proc { |x| x.send(:to_f) }
  end
end
p numbers.map(&ToF.new)

puts "# 5 - monkey patching it onto symbol"
class Symbol
  def to_proc
    proc { |x| x.send(self) }
  end
end
p numbers.map(&:to_f)
