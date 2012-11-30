# encoding: UTF-8

class SkillResolver < PSquaredResolver

  # ALL SKILLS
  get %r{^/skills/?$}i do
    resolve("skill", "all", 1, request.params)
  end

  get %r{^/skills/(\d+)/?$}i do |page|
    resolve("skill", "all", page.to_i, request.params)
  end

  get %r{^/skills/(\w+)/?$}i do |category|
    resolve("skill", "all_of_category", category, 1, request.params)
  end

  get %r{^/skills/(\w+)/(\d+)/?$}i do |category, page|
    resolve("skill", "all_of_category", category, page.to_i, request.params)
  end

  # PROJECTS SKILLS
  get %r{^/projects/skills/?$}i do
    resolve("skill", "from_projects", 1, request.params)
  end

  get %r{^/projects/skills/(\d+)/?$}i do |page|
    resolve("skill", "from_projects", page.to_i, request.params)
  end

  get %r{^/projects/skills/(\w+)/?$}i do |category|
    resolve("skill", "from_projects_of_category", category, 1, request.params)
  end

  get %r{^/projects/skills/(\w+)/(\d+)/?$}i do |category, page|
    resolve("skill", "from_projects_of_category", category, page.to_i, request.params)
  end

  # PROJECT SKILLS
  get %r{^/project/:projectname/skills/?$}i do |projectname|
    resolve("skill", "from_project", projectname, 1, request.params)
  end

  get %r{^/project/:projectname/skills/(\d+)/?$}i do |projectname, page|
    resolve("skill", "from_project", projectname, page.to_i, request.params)
  end

  get %r{^/project/:projectname/skills/(\w+)/?$}i do |projectname, category|
    resolve("skill", "from_project_of_category", projectname, category, 1, request.params)
  end

  get %r{^/project/:projectname/skills/(\w+)/(\d+)/?$}i do |projectname, category, page|
    resolve("skill", "from_project_of_category", projectname, category, page.to_i, request.params)
  end

  # USERS SKILLS
  get %r{^/users/skills/?$}i do
    resolve("skill", "from_users", 1, request.params)
  end

  get %r{^/users/skills/(\d+)/?$}i do |page|
    resolve("skill", "from_users", page.to_i, request.params)
  end

  get %r{^/users/skills/(\w+)/?$}i do |category|
    resolve("skill", "from_users_of_category", category, 1, request.params)
  end

  get %r{^/users/skills/(\w+)/(\d+)/?$}i do |category, page|
    resolve("skill", "from_users_of_category", category, page.to_i, request.params)
  end

  # USER SKILLS
  get %r{^/user/:username/skills/?$}i do |username|
    resolve("skill", "from_user", 1, username, request.params)
  end

  get %r{^/user/:username/skills/(\d+)/?$}i do |username, page|
    resolve("skill", "from_user", username, page.to_i, request.params)
  end

  get %r{^/user/:username/skills/(\w+)/?$}i do |username, category|
    resolve("skill", "from_user_of_category", username, category, 1, request.params)
  end

  get %r{^/user/:username/skills/(\w+)/(\d+)/?$}i do |username, category, page|
    resolve("skill", "from_user_of_category", username, category, page.to_i, request.params)
  end


end