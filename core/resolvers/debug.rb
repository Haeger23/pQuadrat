# encoding: UTF-8

class DebugResolver < PSquaredResolver

  get "/debug/:action/*" do |action, splat|
    splat = splat.split("/")
    args = Array.new(splat.length/2) do |index|
      [splat[index*2], splat[index*2+1]]
    end
    p args
    args = Hash[args]
    p args
    resolve("debug", action, args)
  end

end