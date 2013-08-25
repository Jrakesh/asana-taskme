class PagesController < ApplicationController

  def index
    task = params[:task]
    api  =  params[:api]
    assigne = params[:assignee]
    
    add_task(task,api,assigne) unless task.blank? 
  end
	  
end
