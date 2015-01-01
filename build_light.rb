require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'lifx'
require 'json'

class Signaler
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def signal(params)
    client.discover!

    if params[:build_status] == 'successful'
      client.lights.first.set_color(LIFX::Color.green, duration: 2)
      "signaled success"
    else
      light = client.lights.first
      blink(light, LIFX::Color.red, LIFX::Color.white)
      "signaled failure"
    end
  end

  def blink(light, start_color, end_color)
      5.times do
        light.set_color(start_color, duration: 0)
        light.set_color(end_color, duration: 0)
      end
  end
end

post '/signal' do
  payload = JSON.parse(request.body.read)

  signaler = Signaler.new(LIFX::Client.lan)
  signal = signaler.signal(:build_status => payload["build_status"])

  [200, signal]
end

