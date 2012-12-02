# encoding: UTF-8

class SkillPresenter < Presenter

  def all page, params
    conditions = params["query"] ? ["skills.name LIKE ?", "%#{params["query"]}%"] : []
    skills = Skill.all(:select => "skills.name as name, categories.name as category",
                       :conditions => conditions,
                       :joins => [:category],
                       :offset => (page-1)*50,
                       :limit => 50,
                       :order => "skills.name asc")

    skills.each do |skill|
      category = skill["category"]
      unless data[category]
        data[category] = {skills: [], count: 0}
      end
      data[category][:skills].push(skill.name)
      data[category][:count] += 1
    end
  end

  def all_of_category category, page, params
    conditions = ["categories.name = ?", category]
    if params["query"]
      conditions[0] += " AND skills.name LIKE ?"
      conditions.push("%#{params["query"]}%")
    end

    skills = Skill.all(:select => "skills.name as name",
                       :conditions => conditions,
                       :joins => [:category],
                       :offset => (page-1)*50,
                       :limit => 50,
                       :order => "skills.name asc")

    data[:skills] = skills.collect { |skill| skill.name }
    data[:count] = skills.length
  end

  def one category, skill, params

  end

  def from_projects page, params
    # todo
  end

  def from_project projectname, page, params
    # todo
  end

  def from_users page, params
    # todo
  end

  def from_user username, page, params
    # todo
  end

end