require 'liquid/tags/for_with_random'
require 'liquid/tags/two_columns'
require 'liquid/filters/custom_layout'

module Liquid
  class For < Block
    def slice_collection_using_each(collection, from, to)
      Utils.slice_collection_using_each(collection, from, to)
    end
  end
end
