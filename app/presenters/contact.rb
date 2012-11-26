# encoding: UTF-8

class ContactPresenter < Presenter

  def contact
    view[:title] = "Contact"
    view[:developer] = [
        {username: "friedolin"},
        {username: "willi"},
        {username: "simone"},
        {username: "lukas"},
        {username: "alex"}
    ].each do |developer|
      vars = Presenter.collect("user", "show", nil, developer[:username])
      ["forename", "surname"].each do |key|
        developer[key] = vars[key]
      end
    end


    view[:mail] = "info@p-squared.org"
  end

  def imprint
    view[:title] = "Imprint"
  end

end