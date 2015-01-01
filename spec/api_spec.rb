require 'rack/test'
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
      allow(signaler).to receive(:foo)

      post '/signal'

      expect(last_response).to be_ok
    end

    it 'tells the signaler to signal' do
      expect(signaler).to receive(:foo)

      post '/signal'
    end

    it 'reports on what it did' do
      allow(signaler).to receive(:foo).and_return('success')

      post '/signal'

      expect(last_response.body).to match(/success/)
    end
  end
end
