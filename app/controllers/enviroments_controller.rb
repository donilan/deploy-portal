class EnvironmentsController < ApplicationController
  def index
    @groups = EnvGroups.all
  end
end
