class TasksController < ApplicationController
  def index
  end

  def new
    @project = Project.new()
  end
end
