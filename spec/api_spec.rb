require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rack/test'
require 'json'
require_relative '../build_light'

describe 'api' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'POST /signal' do
    let!(:signaler) { instance_double("Signaler") }

    before do
      allow(Signaler).to receive(:new).and_return(signaler)
    end

    it 'yields 200 status' do
      allow(signaler).to receive(:signal)

      post '/signal', { :build_status => 'failed' }.to_json

      expect(last_response).to be_ok
    end

    it 'tells the signaler to signal and reports on what it did' do
      expect(signaler).to receive(:signal).
        with({ :build_status => 'successful' }).
        and_return('success')

      post '/signal', { :build_status => 'successful' }.to_json

      expect(last_response.body).to match(/success/)
    end
  end
end

describe Signaler do
  describe '#signal' do
    let(:client) { instance_double('LIFX::Client') }

    it 'blinks the color to red on the first light' do
      light = double('LIFX::Light')
      allow(client).to receive(:discover!)

      expect(client).to receive(:lights).and_return([light])
      expect(light).to receive(:set_color).with(LIFX::Color.red, duration: 0).exactly(5).times
      expect(light).to receive(:set_color).with(LIFX::Color.white, duration: 0).exactly(5).times

      signal = Signaler.new(client).signal(:build_status => 'failed')
      expect(signal).to eql("signaled failure")
    end

    it 'sets the color to green on the first light' do
      light = double('LIFX::Light')
      allow(client).to receive(:discover!)

      expect(client).to receive(:lights).and_return([light])
      expect(light).to receive(:set_color).with(LIFX::Color.green, duration: 2)

      signal = Signaler.new(client).signal(:build_status => 'successful')
      expect(signal).to eql("signaled success")
    end
  end
end
