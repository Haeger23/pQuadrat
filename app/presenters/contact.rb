# encoding: UTF-8

class ContactPresenter < Presenter

  def contact
    page[:title] = "Contact"
    data[:developer] = [
        {username: "friedolin"},
        {username: "willi"},
        {username: "simone"},
        {username: "lukas"},
        {username: "alex"}
    ].each do |developer|
      vars = Presenter.collect("user", "show", developer[:username])
      ["forename", "surname"].each do |key|
        developer[key] = vars[key]
      end
    end


    data[:mail] = "info@p-squared.org"
  end

  def imprint
    page[:title] = "Imprint"
  end

end