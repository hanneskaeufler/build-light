require 'rubygems'
require 'bundler/setup'
require 'sinatra'

class Signaler
  def foo
    "bar"
  end
end

post '/signal' do
  signaler = Signaler.new
  res = signaler.foo

  [200, res]
end

