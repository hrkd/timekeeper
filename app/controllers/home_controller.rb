class HomeController < ApplicationController
  def index
    user = current_user
    @tasks = user.tasks
  end
  def tasks
  end
end
