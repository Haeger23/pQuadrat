class ProjectService < Service

  def all(page, count)
    Project.all(
        :order => "updated_at desc",
        :offset => count*(page-1),
        :limit => count
    )
  end


end