# encoding: UTF-8

class SkillResolver < PSquaredResolver

  get %r{^/skills/?$}i do
    resolve("skill", "skills", 1, request.params)
  end

  get %r{^/skills/(\d+)/?$}i do |page|
    resolve("skill", "skills", page.to_i, request.params)
  end

  get %r{^/skills/(\w+)/?$}i do |category|
    resolve("skill", "skills_category", category, 1, request.params)
  end

  get %r{^/skills/(\w+)/(\d+)/?$}i do |category, page|
    resolve("skill", "skills_category", category, page.to_i, request.params)
  end


end