# encoding: UTF-8

class AdminPresenter < Presenter

  def add_category params
    category = feedback!(Category.create(name: params[:name]))
    data[:id] = category.id
  end

  def add_project params
    skills = params[:skills] || ""
    ar_skills = []
    skills.split(",").each do |skill|
      skill = Skill.find_by_url(skill.strip)
      ar_skills.push(skill) if skill
    end
    skills = ar_skills
    project = feedback!(Project.create(
      title: params[:title],
      about: params[:about],
      progress: params[:progress],
      skills: skills
    ))
  end

  def add_project_skill params
    project = params[:project] || ""
    skill = params[:skill] || ""
    project = Project.find_by_url(project)
    skill = Skill.find_by_url(skill)
    project_skill = feedback!(ProjectSkill.create(
      project: project,
      skill: skill,
      weight: params[:weight]
    ))
    # todo test this function
  end

  def add_request params
    params["user"] = User.find_by_url(params["user"] || "")
    params["project"] = Project.find_by_url(params["project"] || "")
    params["is_invitation"] = !!params["is_invitation"]
    p params
    request = feedback!(Request.create_with_hash(params, "user", "project", "message", "is_invitation"))
    # todo test this function
  end

  def add_request_skill params

    # todo add request_skill
  end

  def add_skill params
    params["category"] = Category.find_by_url(params["category"] || "")
    skill = feedback!(Skill.create(
      name: params["name"],
      category: category
    ))
    data[:id] = skill.id
  end

  def add_user params
    feedback!(User.create_with_hash(params, "username", "password", "mail", "image", "forename", "surname", "birthday", "website"))
  end

  def add_user_project params
    # todo add user_project
  end

  def add_user_project_skill params
    # todo add user_project_skill
  end

  def add_user_skill params
    # todo add user_skill
  end

  def export_all
    data[:time_schema] = Presenter.collect("admin", "export_schema")[:time]
    data[:time_data] = Presenter.collect("admin", "export_data")[:time]
  end

  def import_schema
    t1 = Time.now
    con = ActiveRecord::Base.connection
    con.execute("DROP DATABASE IF EXISTS p_squared;");
    con.execute("CREATE DATABASE p_squared;");
    system "mysql -u root p_squared < "+PSquared.path+"/../schema.sql"
    t2 = Time.now
    data[:time] = ("%.4f" % (t2-t1))
  end

  def export_schema
    t1 = Time.now
    system "mysqldump -u root --no-data --tables p_squared > "+PSquared.path+"/../schema.sql"
    t2 = Time.now
    data[:time] = ("%.4f" % (t2-t1))
  end

  def import_all
    data[:time_schema] = Presenter.collect("admin", "import_schema")[:time]
    data_add(Presenter.collect("admin", "import_data"))
  end

  def import_data
    files = Dir[PSquared.path+"/../data/*.sql"]
    len = files.length.to_s.length
    dir =
    files.each_with_index do |file,index|
      t1 = Time.now
      system "mysql -u root p_squared < "+file
      t2 = Time.now
      data[("time%#{len}d" % index).to_sym] = ("%.4f" % (t2-t1))
    end
  end

  def export_data
    files = Dir[PSquared.path+"/../data/*.sql"]
    p files
    files.each do |file|
      File.delete(file)
    end
    t1 = Time.now
    system "mysqldump -u root --skip-triggers --compact --no-create-info p_squared > "+PSquared.path+"/../data/#{t1.to_i}.sql"
    t2 = Time.now
    data[:time] = ("%.4f" % (t2-t1))
  end

end