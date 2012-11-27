# encoding: UTF-8

class HelpResolver < PSquaredResolver

  get "/help" do
    resolve("help", "overview", request.params)
  end

end