# encoding: UTF-8

class DebugResolver < ViewResolver

  get "/debug/:action/*" do |action, splat|
    resolve("debug", action, request.params)
  end

  get "/api" do
    resolve("debug", "api")
  end


end