# encoding: UTF-8

class SearchResolver < PSquaredResolver

  get %r{^/search/all/?$}i do
    query = params["query"] || ""
    if query == ""
      resolve("search", "empty")
    else
      resolve("search", "all", query)
    end
  end

  get %r{^/search/(projects|users)/?$}i do |action|
    query = params["query"] || ""
    action.downcase!
    if query == ""
      resolve(action[0..-2], "list", 1)
    else
      resolve("search", action, query, 1)
    end
  end

end