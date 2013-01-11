# encoding: UTF-8

class ContactResolver < Resolver

  get "/contact" do
    resolve("contact", "contact")
  end

  get "/imprint" do
    resolve("contact", "imprint")
  end


end