# encoding: UTF-8

class ViewResolver < Resolver
  helpers do
    def user
      request.env['user']
    end
  end
end