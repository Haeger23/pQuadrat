# encoding: UTF-8

class SearchPresenter < Presenter

  def empty
    page[:search] = "All"
    page[:title] = "No valid search"
    # todo find all users and projects
  end

  def all query, pageNumber
    step = 10

    page[:search] = "All"
    page[:query] = query
    page[:title] = "Search for '#{query}' in projects and users"
    # todo find all users and projects with the given query

    data[:page_count] = 1 + User.count/step
    data[:page] = pageNumber
    stop(404, "There is no user list ##{pageNumber}, last user is ##{data[:page_count]}") if data[:page] > data[:page_count]
  end

  def projects query, pageNumber
    conditions = ["title LIKE ? OR about LIKE ?", "%#{query}%", "%#{query}%"]
    step = 10

    page[:search] = "Projects"
    page[:query] = query
    page[:title] = "Search for '#{query}' in projects"
    # todo find all projects with the given query

    data[:page_count] = 1 + Project.where(conditions).count/step
    data[:page] = pageNumber
    stop(404, "There is no user search list ##{pageNumber}, last user search list is ##{data[:page_count]}") if data[:page] > data[:page_count]

    Project.all(
        :conditions => conditions,
        :offset => step*(pageNumber-1),
        :limit => step,
        :order => "updated_at desc"
    )
  end

  def users query, pageNumber
    conditions = ["username LIKE ? OR about LIKE ?", "%#{query}%", "%#{query}%"]
    step = 10
    data[:page_count] = 1 + User.where(conditions).count/step
    data[:page] = pageNumber
    stop(404, "There is no user search list ##{pageNumber}, last user search list is ##{data[:page_count]}") if data[:page] > data[:page_count]

    page[:search] = "Users"
    page[:query] = query
    page[:title] = "Search for '#{query}' in users"

    User.all(
       :conditions => conditions,
       :offset => step*(pageNumber-1),
       :limit => step,
       :order => "updated_at desc"
    )
  end

end