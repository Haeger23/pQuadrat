# encoding: UTF-8

class ErrorResolver < PSquaredResolver

  error 403 do
    resolve("error", "not_allowed")
  end

  error 404 do
    resolve("error", "not_found")
  end

end