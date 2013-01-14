class UserService < Service

  def users_for_page(page, count)
    User.all(
        :order => "updated_at desc",
        :offset => count*(page-1),
        :limit => count
    )
  end


end