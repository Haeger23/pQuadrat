# encoding: UTF-8

class SearchPresenter < Presenter

  def init
    @step = 10
  end

  def empty
    page[:search] = "All"
    page[:title] = "No valid search"
    # todo find all users and projects
  end

  def all(params, pageNumber)
    query = params["query"] || ""

    page[:search] = "All"
    page[:query] = query
    page[:title] = "Search for <span class='queryPart'>#{query}</span> in projects and users"

    data[:count] = Searchable.count(query)
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no user list ##{pageNumber}, last user is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data["items"] = Searchable.all(
        query,
        offset: @step*(pageNumber-1),
        limit: @step
    )
  end

  def projects(params, pageNumber)
    query = params["query"] || ""

    page[:search] = "Projects"
    page[:query] = query
    page[:title] = "Search for <span class='queryPart'>#{query}</span> in projects"

    data[:count] = Searchable.project_count(query)
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no project search list ##{pageNumber}, last project search list is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data["items"] = Searchable.projects(
        query,
        offset: @step*(pageNumber-1),
        limit: @step
    )
  end

  def users(params, pageNumber)
    query = params["query"] || ""

    data[:count] = Searchable.user_count(query)
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no user search list ##{pageNumber}, last user search list is ##{data[:page_count]}") if data[:page] > data[:page_count]

    page[:search] = "Users"
    page[:query] = query
    page[:title] = "Search for <span class='queryPart'>#{query}</span> in users"

    data["items"] = Searchable.users(
        query,
        offset: @step*(pageNumber-1),
        limit: @step,
        order: "updated_at desc"
    )
  end

end