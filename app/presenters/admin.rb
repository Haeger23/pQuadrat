# encoding: UTF-8

class AdminPresenter < Presenter

  def add_category params
    category = feedback(Category.create(name: params[:name]))
    data[:id] = category.id
  end

  def add_project params
    skills = params[:skills] || ""
    if skills
      ar_skills = []
      skills.split(",").gsub(/\s/, "").each do |skill|
        skill = Skill.find_by_url(skill)
        ar_skills.push(skill) if skill
      end
      skills = ar_skills
    end
    project = feedback(Project.create(
      title: params[:title],
      about: params[:about],
      progess: params[:progress],
      skills: skills
    ))
    data[:id] = project.id
  end

  def add_project_skill params
    project = params[:project] || ""
    skill = params[:skill] || ""
    project = Project.find_by_url(project)
    skill = Skill.find_by_url(skill)
    project_skill = feedback(ProjectSkill.create(
      project: project,
      skill: skill,
      weight: params[:weight]
    ))
    data[:id] = project_skill.id
    # todo test this function
  end

  def add_request params
    user = params[:user] || ""
    project = params[:project] || ""
    user = User.find_by_url(user)
    project = Project.find_by_url(project)
    request = feedback(Request.create(
      user: user,
      project: project,
      message: params[:message],
      is_invitation: params[:is_invitation].to_bool
    ))
    # todo test this function
  end

  def add_request_skill params

    # todo add request_skill
  end

  def add_skill params
    category = params[:category] || ""
    category = Category.find_by_url(category)
    skill = feedback(Skill.create(
      name: params[:name],
      category: category
    ))
    data[:id] = skill.id
  end

  def add_user params
    # todo add_user
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

  def update_database
    t1 = Time.now
    con = ActiveRecord::Base.connection
    con.execute("DROP DATABASE IF EXISTS p_squared;");
    con.execute("CREATE DATABASE p_squared;");
    p "mysql -u root p_squared < "+PSquared.path+"/../p_squared.sql"
    system "mysql -u root p_squared < "+PSquared.path+"/../p_squared.sql"
    t2 = Time.now
    data[:time] = ((t2-t1)*1000).to_i/1000.0
  end

end