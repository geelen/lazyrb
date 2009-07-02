# Created by IntelliJ IDEA.
# User: glen
# Date: 02/07/2009
# Time: 1:01:39 PM
# To change this template use File | Settings | File Templates.

require File.dirname(__FILE__) + '/common'

test1 = (1..4).to_a.map(&:to_s!)

def some_method i
  i.to_s!
end

# FAILS
# test2 = (1..10).to_a.map(some_method)

class Object
  def method_missing name, *args, &blk
    if name.to_s =~ /^(.+)_$/
      puts "doing #{name} => #{$1}"
      proc { |i|
        send($1.to_sym, *(args + [i]), &blk)
      }
    end
  end
end

# WINS
test3 = (1..4).to_a.map(&some_method_)

def curry_mmm(a,b)
  a + b
end

# OMG
test4 = (1..4).to_a.map(&curry_mmm_(5))
p test4

#  OUTPUT:
#
#  1 => "1"
#  2 => "2"
#  3 => "3"
#  4 => "4"
#  doing some_method_ => some_method
#  1 => "1"
#  2 => "2"
#  3 => "3"
#  4 => "4"
#  doing curry_mmm_ => curry_mmm
#  [6, 7, 8, 9]
