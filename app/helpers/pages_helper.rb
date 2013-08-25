module PagesHelper
  require 'httparty'
  require "net/https"
  require 'open-uri'
  require 'openssl'

  # Author:: Rakesh Jha
  # Date:: Aug 22, 2013
  # Purpose:: Adds new task to Asana workspace (via Asana API)

  def add_task(task,api,assignee)    	
    result = JSON.parse(open("https://app.asana.com/api/1.0/users/me", :http_basic_authentication=>[api, " "]).read)
    workspace_id = result['data']['workspaces'][0]["id"]

    uri = URI.parse("https://app.asana.com/api/1.0/tasks")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    header = { "Content-Type" => "application/json" }
    req = Net::HTTP::Post.new(uri.path, header)
    req.basic_auth(api, '')
    # creates a json data of request
    req.body = {
      "data" => {
         "workspace" => workspace_id,
	 "name" => task,
	 "assignee" => assignee
       }
     }.to_json()
     
     # creates new task and generates response
     response = http.start { |http| http.request(req) }     
     body = JSON.parse(response.body)

     # status message
     @status = body['errors'] ? "Error is - " + body["errors"][0]["message"] : "Hi " + result["data"]["name"] + " , your task is added!"
  end 

end
