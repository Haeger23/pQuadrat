# encoding: UTF-8

class SearchPresenter < Presenter

  def empty
    page[:search] = "All"
    page[:title] = "No valid search"
    # todo find all users and projects
  end

  def all query
    page[:search] = "All"
    page[:query] = query
    page[:title] = "Search for '#{query}' in projects and users"
    # todo find all users and projects with the given query
  end

  def projects query
    page[:search] = "Projects"
    page[:query] = query
    page[:title] = "Search for '#{query}' in projects"
    # todo find all projects with the given query
  end

  def users query
    page[:search] = "Users"
    page[:query] = query
    page[:title] = "Search for '#{query}' in users"
    # todo find all users with the given query
  end

end