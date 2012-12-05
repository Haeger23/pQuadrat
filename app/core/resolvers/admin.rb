# encoding: UTF-8

class AdminResolver < PSquaredResolver

  post %r{^/admin/category/?$}i do
    resolve("admin", "add_category", params)
  end

  post %r{^/admin/project/?$}i do
    resolve("admin", "add_project", params)
  end

  post %r{^/admin/project_skill/?$}i do
    resolve("admin", "add_project_skill", params)
  end

  post %r{^/admin/request/?$}i do
    resolve("admin", "add_request", params)
  end

  post %r{^/admin/request/?$}i do
    resolve("admin", "add_request_skill", params)
  end

  post %r{^/admin/skill/?$}i do
    resolve("admin", "add_skill", params)
  end

  post %r{^/admin/user/?$}i do
    resolve("admin", "add_user", params)
  end

  post %r{^/admin/user_project/?$}i do
    resolve("admin", "add_user_project", params)
  end

  post %r{^/admin/user_project_skill/?$}i do
    resolve("admin", "add_user_project_skill", params)
  end

  post %r{^/admin/user_skill/?$}i do
    resolve("admin", "add_user_skill", params)
  end

  get %r{^/admin/db/?$}i do
    resolve("admin", "update_database")
  end

end