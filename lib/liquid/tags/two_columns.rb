module Liquid
  module Tags

    class TwoColumns < ::Liquid::Block

      def initialize(tag_name, markup, tokens, context)
        @tokens = tokens.take_while {|e| e != "{% endtwocolumns %}"}
        @content = @tokens.first.strip
        super
      end

      def render(context)
        regexp = %r{<img src=\"([^"]+)\" alt=\"\" />(.*)}m
        _, img_src, rest = regexp.match(@content).to_a
        if img_src and rest 
          template = <<-EOL
            <div class="group01">
              <div class="about">
                <div class="block01">
          #{Nokogiri::HTML::DocumentFragment.parse(rest).to_html}
                </div>
              </div>
              <img src="#{img_src}" alt="image" width="712" >
            </div>
          EOL
        else
          template = ""
        end
        template
      end

    end

    class IPad < ::Liquid::Block

      def initialize(tag_name, markup, tokens, context)
        @tokens = tokens.take_while {|e| e != "{% endipad %}"}
        @content = @tokens.first.strip
        super
      end

      def render(context)
        regexp = %r{<img src=\"([^"]+)\" alt=\"\" />(.*)}m
        _, img_src, rest = regexp.match(@content).to_a
        if img_src and rest 
          template = <<-EOL
            <div class="group03">
              <div class="about">
          #{Nokogiri::HTML::DocumentFragment.parse(rest).to_html}
              </div>
              <img src="#{img_src}" alt="image" width="684" >
            </div>
          EOL
        else
          template = ""
        end
        template
      end

    end
    class CenteredImage < ::Liquid::Block

      def initialize(tag_name, markup, tokens, context)
        @tokens = tokens.take_while {|e| e != "{% endcentered %}"}
        @content = @tokens.first.strip
        super
      end

      def render(context)
        regexp = %r{<img src=\"([^"]+)\" alt=\"\" />(.*)}m
        _, img_src = regexp.match(@content).to_a
        if img_src
          template = <<-EOL
            <div class="group04">
              <img src="#{img_src}" alt="image" width="940" >
            </div>
          EOL
        else
          template = ""
        end
        template
      end

    end
    class IPhone < ::Liquid::Block

      def initialize(tag_name, markup, tokens, context)
        @tokens = tokens.take_while {|e| e != "{% endiphone %}"}
        @content = @tokens.first.strip
        super
      end

      def render(context)
        regexp = %r{<img src=\"([^"]+)\" alt=\"\" />(.*)}m
        _, img_src, rest = regexp.match(@content).to_a
        if img_src and rest 
          template = <<-EOL
            <div class="group05">
              <div class="block01">
                <img src="#{img_src}" alt="image" width="383" >
                <div class="about">
          #{Nokogiri::HTML::DocumentFragment.parse(rest).to_html}
                </div>
              </div>
            </div>
          EOL
        else
          template = ""
        end
        template
      end

    end
    class TwoIPhones < ::Liquid::Block

      def initialize(tag_name, markup, tokens, context)
        @tokens = tokens.take_while {|e| e != "{% endtwoiphones %}"}
        @content = @tokens.first.strip
        super
      end

      def render(context)
        regexp = %r{<img src=\"([^"]+)\" alt=\"\" />(.*?)<img src=\"([^"]+)\" alt=\"\" />(.*)}m
        _, img_src1, rest1, img_src2, rest2 = regexp.match(@content).to_a
        if [img_src1, rest1, img_src2, rest2].all?
          template = <<-EOL
            <div class="group05">
              <div class="block02">
                <div class="col">
                  <img src="#{img_src1}" alt="image" width="383" >
          #{Nokogiri::HTML::DocumentFragment.parse(rest1).to_html}
                </div>
                <div class="col">
                  <img src="#{img_src2}" alt="image" width="383" >
          #{Nokogiri::HTML::DocumentFragment.parse(rest2).to_html}
                </div>
              </div>
            </div>
          EOL
        else
          template = ""
        end
        template
      end

    end

    class CenteredIPhone < ::Liquid::Block

      def initialize(tag_name, markup, tokens, context)
        @tokens = tokens.take_while {|e| e != "{% endcenterediphone %}"}
        @content = @tokens.first.strip
        super
      end

      def render(context)
        regexp = %r{<img src=\"([^"]+)\" alt=\"\" />(.*)}m
        _, img_src = regexp.match(@content).to_a
        if img_src
          template = <<-EOL
            <div class="group05">
              <div class="block03">
                <img src="#{img_src}" alt="image" width="700">
              </div>
            </div>
          EOL
        else
          template = ""
        end
        template
      end

    end
    ::Liquid::Template.register_tag('twocolumns', TwoColumns)
    ::Liquid::Template.register_tag('ipad', IPad)
    ::Liquid::Template.register_tag('centered', CenteredImage)
    ::Liquid::Template.register_tag('iphone', IPhone)
    ::Liquid::Template.register_tag('twoiphones', TwoIPhones)
    ::Liquid::Template.register_tag('centerediphone', CenteredIPhone)
  end
end