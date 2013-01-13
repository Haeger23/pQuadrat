# encoding: UTF-8

class Searchable

  @@sql = "SELECT id, 'user' as type, %s FROM users WHERE username LIKE ? or about LIKE ? UNION SELECT id, 'project' as type, %s FROM projects WHERE title LIKE ? OR about LIKE ?"

  def self.all(query, *options)
    options = {
      order: "updated_at DESC",
      offset: 0,
      limit: 10
    }.merge(options.extract_options!)

    orderColumn = options[:order].split(" ")[0]
    sql = (@@sql % [orderColumn, orderColumn]) + " ORDER BY #{options[:order]} LIMIT #{options[:offset]}, #{options[:limit]}"
    ids = {projects: [], users: []}
    items = User.find_by_sql([sql, "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"]).each do |item|
      if item.type == "user"
        ids[:users].push(item.id)
      else
        ids[:projects].push(item.id)
      end
    end

    unless ids[:users].empty?
      users = {}
      User.find(ids[:users]).each do |user|
        users[user.id] = user
      end
    end
    unless ids[:projects].empty?
      projects = {}
      Project.find(ids[:projects]).each do |project|
        projects[project.id] = project
      end
    end

    regexp = Regexp.new("("+Regexp.escape(query)+")", Regexp::IGNORECASE)
    items.map do |item|
      if item.type == "user"
        user = users[item.id]
        username = user.username && user.username.gsub(regexp, '<span class="queryPart">\1</span>')
        about = user.about && user.about.gsub(regexp, '<span class="queryPart">\1</span>')
        {type: item.type, about: about, username: username, item: user}
      else
        project = projects[item.id]
        title = project.title && project.title.gsub(regexp, '<span class="queryPart">\1</span>')
        about = project.about && project.about.gsub(regexp, '<span class="queryPart">\1</span>')
        {type: item.type, about: about, title: title, item: project}
      end
    end
  end

  def self.projects(query, *options)
    options = {
        order: "updated_at DESC",
        offset: 0,
        limit: 10
    }.merge(options.extract_options!)

    regexp = Regexp.new("("+Regexp.escape(query)+")", Regexp::IGNORECASE)
    Project.all(
        conditions: ["title LIKE ? OR about LIKE ?", "%#{query}%", "%#{query}%"],
        offset: options[:offset],
        limit: options[:limit],
        order: options[:order]
    ).map do |project|
      title = project.title && project.title.gsub(regexp, '<span class="queryPart">\1</span>')
      about = project.about && project.about.gsub(regexp, '<span class="queryPart">\1</span>')
      {title: title, about: about, item: project}
    end
  end

  def self.users(query, *options)
    options = {
        order: "updated_at DESC",
        offset: 0,
        limit: 10
    }.merge(options.extract_options!)

    regexp = Regexp.new("("+Regexp.escape(query)+")", Regexp::IGNORECASE)
    User.all(
        conditions: ["username LIKE ? OR about LIKE ?", "%#{query}%", "%#{query}%"],
        offset: options[:offset],
        limit: options[:limit],
        order: options[:order]
    ).map do |user|
      username = user.username && user.username.gsub(regexp, '<span class="queryPart">\1</span>')
      about = user.about && user.about.gsub(regexp, '<span class="queryPart">\1</span>')
      {username: username, about: about, item: user}
    end
  end

  def self.count(query)
    self.user_count(query) + self.project_count(query)
  end

  def self.user_count(query)
    User.where(["username LIKE ? OR about LIKE ?", "%#{query}%", "%#{query}%"]).count
  end

  def self.project_count(query)
    Project.where(["title LIKE ? OR about LIKE ?", "%#{query}%", "%#{query}%"]).count
  end
end