# encoding: UTF-8

class LoginResolver < PSquaredResolver

  get "*" do
    p request.params["session"]
    pass
  end

end