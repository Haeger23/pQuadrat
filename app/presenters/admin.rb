# encoding: UTF-8

class AdminPresenter < Presenter

  def add_category params
    data[:required] = ["name"]
    data[:optional] = []

    feedback!(Category.create_with_hash(params, "name"))
  end

  def add_project params
    data[:required] = ["title"]
    data[:optional] = ["about", "progress", "skills"]

    params["skills"] = params["skills"] || ""
    params["skills"] = params["skills"].strip
    ar_skills = []
    unless params["skills"].empty?
      params["skills"].split(",").each do |skill|
        skill = Skill.find_by_name(skill.strip)
        ar_skills.push(skill) if skill
      end
    end
    params["skills"] = ar_skills

    feedback!(Project.create_with_hash(params, "title", "about", "progress", "skills"))
  end

  def add_project_skill params
    data[:required] = ["project", "skill", "weight"]
    data[:optional] = []

    params["project"] = Project.find_by_title(params["project"] || "")
    params["skill"] = Skill.find_by_name(params["skill"] || "")
    params["weight"] ||= 50
    feedback!(ProjectSkill.create_with_hash(params, "project", "skill", "weight"))
    # todo test this function
  end

  def add_request params
    data[:required] = ["user", "project", "message"]
    data[:optional] = ["is_invitation"]

    params["user"] = User.find_by_username(params["user"] || "")
    params["project"] = Project.find_by_title(params["project"] || "")
    params["is_invitation"] = !!params["is_invitation"]
    feedback!(Request.create_with_hash(params, "user", "project", "message", "is_invitation"))
    # todo test this function
  end

  def add_request_skill params
    data[:required] = ["user", "project", "skill"]
    data[:optional] = []

    params["user"] = User.find_by_username(params["user"] || "")
    params["project"] = Project.find_by_title(params["project"] || "")
    params["request"] = Request.find_by_user_id_and_project_id(params["user"] && params["user"].id, params["project"] && params["project"].id)
    params["skill"] = Skill.find_by_name(params["skill"] || "")
    params["project_skill"] = ProjectSkill.find_by_project_id_and_skill_id(params["project"] && params["project"].id, params["skill"] && params["skill"].id)
    params["weight"] ||= 50
    RequestSkill.create_with_hash(params, "request", "project_skill", "weight")
    # todo add request_skill
  end

  def add_skill params
    data[:required] = ["name", "category"]
    data[:optional] = []

    params["category"] = Category.find_by_name(params["category"] || "")
    feedback!(Skill.create_with_hash(params, "name", "category"))
    # todo test this function
  end

  def add_user params
    data[:required] = ["username", "password", "mail"]
    data[:optional] = ["forename", "surname", "birthday", "website", "skills"]

    params["skills"] = params["skills"] || ""
    params["skills"] = params["skills"].strip
    ar_skills = []
    unless params["skills"].empty?
      params["skills"].split(",").each do |skill|
        skill = Skill.find_by_name(skill.strip)
        ar_skills.push(skill) if skill
      end
    end
    params["skills"] = ar_skills

    feedback!(User.create_with_hash(params, "username", "password", "mail", "forename", "surname", "birthday", "website", "skills"))
    # todo test this function
  end

  def add_user_project params
    data[:required] = ["user", "project"]
    data[:optional] = []

    params["user"] = User.find_by_username(params["user"] || "")
    params["project"] = Project.find_by_title(params["project"] || "")
    feedback!(UserProject.create_with_hash(params, "user", "project"))
    # todo test this function
  end

  def add_user_project_skill params
    data[:required] = ["user", "project", "skill"]
    data[:optional] = ["weight"]

    params["user"] = User.find_by_username(params["user"] || "")
    params["project"] = Project.find_by_title(params["project"] || "")
    params["skill"] = Skill.find_by_name(params["skill"] || "")
    params["project_skill"] = ProjectSkill.find_by_project_id_and_skill_id(params["project"] && params["project"].id, params["skill"] && params["skill"].id)
    params["weight"] ||= 50
    feedback!(UserProjectSkill.create_with_hash(params, "user", "project_skill", "weight"))
    # todo test this function
  end

  def add_user_skill params
    data[:required] = ["user", "skill", "weight"]
    data[:optional] = []

    params["user"] = User.find_by_username(params["user"] || "")
    params["skill"] = Skill.find_by_name(params["skill"] || "")
    params["weight"] ||= 50
    feedback(!UserSkill.create_with_hash(params, "user", "skill", "weight"))
    # todo test this function
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
    files.each do |file|
      File.delete(file)
    end
    t1 = Time.now
    system "mysqldump -u root --skip-triggers --compact --no-create-info p_squared > "+PSquared.path+"/../data/#{t1.to_i}.sql"
    t2 = Time.now
    data[:time] = ("%.4f" % (t2-t1))
  end

end