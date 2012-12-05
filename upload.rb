#!/usr/bin/env ruby
#locomotive_api_theme_assets GET    /locomotive/api/theme_assets(.:format)                         locomotive/api/theme_assets#index
require 'rubygems'
require 'rest-client'
require 'json'

resp = RestClient.post('http://new-turumburum-com.fkonstantin.locum.ru/locomotive/api/tokens.json', 
                email: "point@dontpanic.com.ua",
                password: "d951d3892b0db3057ffd1"
)
resp = JSON.parse(resp)

RestClient.post('http://new-turumburum-com.fkonstantin.locum.ru/locomotive/api/theme_assets', {
    xhr: true,
    content_locale: "ru",
    theme_asset: {
      plain_text_type: "stylesheet",
      plain_text_type_text: "stylesheet",
      performing_plain_text: "",
      source: File.new("fff.gif", "rb"),
      folder: "testapi"
    },
    auth_token: resp["token"]
}
)
