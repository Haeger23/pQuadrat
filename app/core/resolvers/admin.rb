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

  post %r{^/admin/request_skill/?$}i do
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



  get %r{^/db/?$}i do
    resolve("admin", "db")
  end

  get %r{^/db/import/?$}i do
    resolve("admin", "import")
  end

  get %r{^/db/import/all/?$}i do
    resolve("admin", "import_all")
  end

  get %r{^/db/import/schema/?$}i do
    resolve("admin", "import_schema")
  end

  get %r{^/db/import/data/?$}i do
    resolve("admin", "import_data")
  end

  get %r{^/db/export/?$}i do
    resolve("admin", "export")
  end

  get %r{^/db/export/all/?$}i do
    resolve("admin", "export_all")
  end

  get %r{^/db/export/schema/?$}i do
    resolve("admin", "export_schema")
  end

  get %r{^/db/export/data/?$}i do
    resolve("admin", "export_data")
  end



end