# encoding: UTF-8

class SkillPresenter < Presenter

  def initialize
    super
    @step = 10
  end

  def list params, pageNumber
    data[:count] = Skill.count
    data[:page_count] = data[:count] > 0 ? 1+(data[:count]-1)/@step : 1
    data[:page] = pageNumber
    stop(404, "There is no skill list ##{pageNumber}, last skill is ##{data[:page_count]}") if data[:page] > data[:page_count]

    data[:skills] = Skill.all(
        :joins => :category,
        :order => "skills.name asc, categories.name asc",
        :offset => @step*(pageNumber-1),
        :limit => @step
    )

    page[:title] = "Skills"
  end

  def all_of_category category, params, pageNumber
    conditions = ["categories.name = ?", category]
    if params["query"]
      conditions[0] += " AND skills.name LIKE ?"
      conditions.push("%#{params["query"]}%")
    end

    skills = Skill.all(:select => "*, skills.name as name",
                       :conditions => conditions,
                       :joins => [:category],
                       :offset => (pageNumber-1)*50,
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
    page[:breadcrumb] = [{url: "skills", title: "Skills"}]

    data["users_count"] = skill.users_count
    data["projects_count"] = skill.projects_count
    data["users"] = skill.users.each do |user|
      diff = (Time.now-Time.parse(user.changed_at)).to_i
      user.changed_at = case diff
        when 0 then 'just now'
        when 1 then 'a second ago'
        when 2..59 then diff.to_s+' seconds ago'
        when 60..119 then 'a minute ago' #120 = 2 minutes
        when 120..3540 then (diff/60).to_i.to_s+' minutes ago'
        when 3541..7100 then 'an hour ago' # 3600 = 1 hour
        when 7101..82800 then ((diff+99)/3600).to_i.to_s+' hours ago'
        when 82801..172000 then 'a day ago' # 86400 = 1 day
        when 172001..518400 then ((diff+800)/(60*60*24)).to_i.to_s+' days ago'
        when 518400..1036800 then 'a week ago'
        else ((diff+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
      end
    end
    data["projects"] = skill.projects.each do |project|
      diff = (Time.now-Time.parse(project.changed_at)).to_i
      project.changed_at = case diff
       when 0 then 'just now'
       when 1 then 'a second ago'
       when 2..59 then diff.to_s+' seconds ago'
       when 60..119 then 'a minute ago' #120 = 2 minutes
       when 120..3540 then (diff/60).to_i.to_s+' minutes ago'
       when 3541..7100 then 'an hour ago' # 3600 = 1 hour
       when 7101..82800 then ((diff+99)/3600).to_i.to_s+' hours ago'
       when 82801..172000 then 'a day ago' # 86400 = 1 day
       when 172001..518400 then ((diff+800)/(60*60*24)).to_i.to_s+' days ago'
       when 518400..1036800 then 'a week ago'
       else ((diff+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
     end
    end
    data["similar"] = skill.similar

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