# encoding: UTF-8

class SkillPresenter < Presenter

  def all page, params
    conditions = params["query"] ? ["skills.name LIKE ?", "%#{params["query"]}%"] : []
    skills = Skill.all(:select => "*, skills.id as id, skills.name as name, categories.name as category, skills.url as url",
                       :conditions => conditions,
                       :joins => [:category],
                       :offset => (page-1)*50,
                       :limit => 50,
                       :order => "skills.name asc")

    skills.each do |skill|
      user_skills = UserSkill.find_all_by_skill_id(skill.id)

      category = skill["category"]
      unless data[category]
        data[category] = {skills: [], count: 0}
      end
      data[category][:skills].push({
        name: skill.name,
        created_at: skill.created_at,
        url: skill.url,
        users: user_skills.length
      })
      data[category][:count] += 1
    end
  end

  def all_of_category category, page, params
    conditions = ["categories.name = ?", category]
    if params["query"]
      conditions[0] += " AND skills.name LIKE ?"
      conditions.push("%#{params["query"]}%")
    end

    skills = Skill.all(:select => "*, skills.name as name",
                       :conditions => conditions,
                       :joins => [:category],
                       :offset => (page-1)*50,
                       :limit => 50,
                       :order => "skills.name asc")

    data[:skills] = skills.collect do |skill| {
        name: skill.name,
        created_at: skill.created_at
    }
    end
    data[:count] = skills.length
  end

  def one category, skill, params
    category = Category.find_by_url(category)
    stop(404, "No category '#{category}' available") unless category
    skill = Skill.find_by_category_id_and_url(category.id, skill)
    stop(404, "No category '#{category}' available") unless skill

    page[:title] = "#{skill.name} (#{category.name})"

    data_add(skill.attributes, "name", "url", "created_at")
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