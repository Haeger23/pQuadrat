# encoding: UTF-8

class SearchResolver < ViewResolver

  get %r{^/search/all/?$}i do
    resolve("search", "all", params, 1)
  end

  get %r{^/search/all/(\d+)/?$}i do |page|
    resolve("search", "all", params, page.to_i)
  end

  get %r{^/search/users/?$}i do
    resolve("search", "users", params, 1)
  end

  get %r{^/search/users/(\d+)/?$}i do |page|
    resolve("search", "users", params, page.to_i)
  end

  get %r{^/search/projects/?$}i do
    resolve("search", "projects", params, 1)
  end

  get %r{^/search/projects/(\d+)/?$}i do |page|
    resolve("search", "projects", params, page.to_i)
  end

end