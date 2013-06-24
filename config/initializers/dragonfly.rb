require 'dragonfly'
#module ImageMagick
  #module Utils
    #private
    #def identify(temp_object)
      ## example of details string:
      ## myimage.png PNG 200x100 200x100+0+0 8-bit DirectClass 31.2kb
      #format, width, height, depth = raw_identify(temp_object).scan(/([A-Z0-9]+) (\d+)x(\d+) .* (\d+)-bit/)[0]
      #{
        #:format => format.downcase.to_sym,
        #:width => width.to_i,
        #:height => height.to_i,
        #:depth => depth.to_i
      #}
    #end
  #end
#end
## initialize Dragonfly ##

app = Dragonfly[:images]
app.configure_with(:rails)
app.configure_with(:imagemagick)

## configure it ##

Dragonfly[:images].configure do |c|
  # Convert absolute location needs to be specified
  # to avoid issues with Phusion Passenger not using $PATH
  convert = `which convert`.strip.presence || "/usr/local/bin/convert"
  identify = `which identify`.strip.presence || /usr/bin/identify
  c.convert_command  = convert
  c.identify_command = identify

  c.allow_fetch_url  = true
  c.allow_fetch_file = true

  c.url_format = '/images/dynamic/:job/:basename.:format'
end
