module Locomotive
  module Liquid
    module Drops

      class ProxyCollection < ::Liquid::Drop
        def shuffle
          self.collection.shuffle
        end
      end
    end
  end
end

module Liquid
  class For < Block
    def render(context)
      context.registers[:for] ||= Hash.new(0)

      collection = context[@collection_name]
      collection = collection.to_a if collection.is_a?(Range)

      return '' unless collection.respond_to?(:each)

      from = if @attributes['offset'] == 'continue'
        context.registers[:for][@name].to_i
      else
        context[@attributes['offset']].to_i
      end

      limit = context[@attributes['limit']]
      to    = limit ? limit.to_i + from : nil


      #p @attributes
      if @attributes['random']
        segment = slice_collection_using_each(collection.shuffle, from, to)
      else
        segment = slice_collection_using_each(collection, from, to)
      end

      return '' if segment.empty?

      segment.reverse! if @reversed

      result = []

      length = segment.length

      # Store our progress through the collection for the continue flag
      context.registers[:for][@name] = from + segment.length

      context.stack do
        segment.each_with_index do |item, index|
          context[@variable_name] = item
          context['forloop'] = {
            'name'    => @name,
            'length'  => length,
            'index'   => index + 1,
            'index0'  => index,
            'rindex'  => length - index,
            'rindex0' => length - index -1,
            'first'   => (index == 0),
            'last'    => (index == length - 1) }

          result << render_all(@nodelist, context)
        end
      end
      result
    end
  end
end

