# encoding: UTF-8

class SearchResolver < PSquaredResolver

  get %r{^/search/all/?$}i do
    query = params[:query] || ""
    if query == ""
      resolve("search", "empty")
    else
      resolve("search", "projects_and_users", query)
    end
  end

  get %r{^/search/(projects|users)/?$}i do |action|
    query = params[:query] || ""
    action.downcase!
    if query == ""
      resolve(action[0..-2], "list")
    else
      resolve("search", action, query)
    end
  end

end