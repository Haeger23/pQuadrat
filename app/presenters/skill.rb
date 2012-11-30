# encoding: UTF-8

class SkillPresenter < Presenter

  def skills page, params
    conditions = []
    if params["query"]
      conditions = ["skills.name LIKE ?", "%#{params["query"]}%"]
    end
    skills = Skill.all(:select => "skills.name as name, categories.name as category",
                       :conditions => conditions,
                       :joins => [:category],
                       :offset => (page-1)*50,
                       :limit => 50,
                       :order => "skills.name asc")

    data[:skills] = Hash.new() {|hash, key| hash[key] = []}
    skills.each { |skill| data[:skills][skill["category"]].push(skill.name) }
  end

  def skills_category category, page, params
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
  end

  def add_category params
    category = Category.create(
        name: params[:name]
    )
    if category.invalid?
      data[:errors] = category.errors.to_hash
      stop(400, category.errors.full_messages.join(", "))
    end
    data[:category] = category.id
  end

  def add_skill params
    category = Category.find_by_name(params[:category])
    skill = Skill.create(
        name: params[:name],
        category: category
    )
    if skill.invalid?
      data[:errors] = skill.errors.to_hash
      stop(400, skill.errors.full_messages.join(", "))
    end
    data[:skill] = skill.id
  end

  def add_user_skill name, category
    category = Category.find_by_name(category)
    # todo
  end

  def add_project_skill name, category
    # todo
  end

  def add_user_project_skill name, category
    # todo
  end

  def add_request_skill name, category
    # todo
  end

end