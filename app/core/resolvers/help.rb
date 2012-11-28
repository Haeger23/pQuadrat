# encoding: UTF-8

class HelpResolver < PSquaredResolver

  get "/help" do
    resolve("help", "overview", request.params)
  end

  get "/help/views" do
    resolve("help", "views")
  end

end