# encoding: UTF-8

class SearchPresenter < Presenter

  def empty
    view["search"] = "All"
    view["title"] = "No valid search"
  end

  def projects_and_users query
    view["search"] = "All"
    view["query"] = query
    view["title"] = "Search for '#{query}' in projects and users"
  end

  def projects query
    view["search"] = "Projects"
    view["query"] = query
    view["title"] = "Search for '#{query}' in projects"
  end

  def users query
    view["search"] = "Users"
    view["query"] = query
    view["title"] = "Search for '#{query}' in users"
  end

end