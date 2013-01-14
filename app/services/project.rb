class ProjectService < Service

  def projects_for_page(page, count)
    Project.all(
        :order => "updated_at desc",
        :offset => count*(page-1),
        :limit => count
    )
  end


end