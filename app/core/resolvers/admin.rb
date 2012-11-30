# encoding: UTF-8

class AdminResolver < PSquaredResolver

  post %r{^/admin/category/?$}i do
    resolve("skill", "add_category", params)
  end

  post %r{^/admin/skill/?$}i do
    resolve("skill", "add_skill", params)
  end

end