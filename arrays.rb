# Created by IntelliJ IDEA.
# User: glen
# Date: 02/07/2009
# Time: 9:14:44 AM
# To change this template use File | Settings | File Templates.

require File.dirname(__FILE__) + '/common'

class TransformingX
  @@transformers = {}
  def self.for obj, &blk
    @@transformers[obj.class] ||= new_transformer_class(obj.class)
    @@transformers[obj.class].new(obj, blk)
  end
  def self.new_transformer_class cls
    Class.new {
      define_method(:initialize) { |obj, blk|
        @obj = obj
        @memo = nil
        @blk = blk
      }
      cls.instance_methods.each { |method|
        define_method(method.to_sym) { |*args|
          @memo ||= @blk.call(@obj)
          @memo.send(method, *args)
        }
      }
    }
  end
end

test1 = (1..10).to_a[0..3].map { |i| i.to_s! }

p test1

test2 = (1..10).to_a.map { |i| i.to_s! }[0..3]

p test2

class Array
  old_map = instance_method(:map)
  define_method(:map) { |&blk|
    old_map.bind(self).call { |i| TransformingX.for(i, &blk) }
  }
end

test3 = (1..10).to_a.map { |i| i.to_s! }[0..3]

p test3

#  output:
#  1 => "1"
#  2 => "2"
#  3 => "3"
#  4 => "4"
#  ["1", "2", "3", "4"]
#  1 => "1"
#  2 => "2"
#  3 => "3"
#  4 => "4"
#  5 => "5"
#  6 => "6"
#  7 => "7"
#  8 => "8"
#  9 => "9"
#  10 => "10"
#  ["1", "2", "3", "4"]
#  1 => "1"
#  2 => "2"
#  3 => "3"
#  4 => "4"
#  ["1", "2", "3", "4"]