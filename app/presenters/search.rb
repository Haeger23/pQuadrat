# encoding: UTF-8

class SearchPresenter < Presenter

  def empty
    page[:search] = "All"
    page[:title] = "No valid search"
  end

  def all query
    page[:search] = "All"
    page[:query] = query
    page[:title] = "Search for '#{query}' in projects and users"
  end

  def projects query
    page[:search] = "Projects"
    page[:query] = query
    page[:title] = "Search for '#{query}' in projects"
  end

  def users query
    page[:search] = "Users"
    page[:query] = query
    page[:title] = "Search for '#{query}' in users"
  end

end