# Created by IntelliJ IDEA.
# User: glen
# Date: 02/07/2009
# Time: 1:03:40 PM
# To change this template use File | Settings | File Templates.

class Object
  define_method(:to_s!) do
    result = self.to_s
    puts self.inspect + " => " + result.inspect
    result
  end
end
