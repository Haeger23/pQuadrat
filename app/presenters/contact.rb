# encoding: UTF-8

class ContactPresenter < Presenter

  def contact
    page[:title] = "Contact"
    data[:developer] = [
        {username: "friedolin"},
        {username: "WKampe"},
        {username: "simone"},
        {username: "lukas"},
        {username: "alex"}
    ].each do |developer|
      Presenter["user"].serve("show", nil, developer[:username]) do |k,v|
        developer[k] = v
      end
    end

    data[:mail] = "info@p-squared.org"
  end

  def imprint
    page[:title] = "Imprint"
  end

end