# encoding: UTF-8

class HelpPresenter < Presenter

  def overview(params)
    page[:title] = "Help"
    api
  end

  def api
    data[:api] = [
        ["users",             "GET",  {}],
        ["projects",          "GET",  {}],
        ["search/all",        "GET",  {}],
        ["search/users",      "GET",  {}],
        ["search/projects",   "GET",  {}],
        ["register",          "GET",  {}],
        ["login",             "GET",  {}],
        ["login",             "POST", {"username" => d("min" => 4, "max" => 30, "unique" => true),
                                       "password" => d("min" => 6, "max" => 30)}],
        ["user",              "POST", {"session"  => d("type" => "string", "min" => 40, "max" => 40),
                                       "username" => d("min" => 4, "max" => 30, "unique" => true),
                                       "password" => d("min" => 6, "max" => 30),
                                       "mail"     => d(),
                                       "forename" => d("required" => false, "max" => 30),
                                       "surname"  => d("required" => false, "max" => 30),
                                       "birthday" => d("required" => false, "type" => "datetime", "max" => "today"),
                                       "skills"   => d("required" => false, "type" => "list")}],
        ["project",           "POST", {"session"  => d("type" => "string", "min" => 40, "max" => 40),
                                       "title"    => d("min" => 4, "max" => 30, "unique" => true),
                                       "progress" => d("required" => false, "type" => "int", "min" => 0, "max" => 100),
                                       "skills"   => d("required" => false, "type" => "list")}],
        ["projects/add",      "GET",  {}],
        ["help",              "GET",  {}],
        ["api",               "GET",  {}]
    ].sort {|a,b| a[0] <=> b[0]}
  end

protected
  def d *args
    options = args.extract_options!

    desc = {
        "required" => true,
        "unique" => false,
        "nil" => false,
        "default" => nil
    }

    if options["type"].nil? or ["string", "int", "datetime", "date"].include?(options["type"])
      desc.merge!({
        "min" => nil,
        "max" => nil
      })
    end

    desc.merge(options)

  end

end