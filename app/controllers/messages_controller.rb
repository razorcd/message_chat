require 'sse'

class MessagesController < ApplicationController
  include ActionController::Live

  def index
  end

  def create
    message = params.permit(:username,:message)["message"]
    username = params.permit(:username,:message)["username"]
    REDIS.publish('messages.create', {"username" => username, "message" => message}.to_json)
    render nothing: true
  end

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)

    begin
      redis = Redis.new
      redis.subscribe("messages.create") do |on|
        on.message do |event, data|
          sse.write(JSON.parse(data), :event => 'refresh')
        end
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
      puts "Stream closed ..."
    ensure
      sse.close
      redis.close
    end
  end

end
