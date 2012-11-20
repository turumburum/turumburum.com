module Liquid
  module Filters
    module CustomLayout

      def custom_layout(input, *args)
        options = args_to_options(args)
        ::Liquid::Template.parse(input, {}).render
      end
    end
    ::Liquid::Template.register_filter(CustomLayout)
  end
end
