require 'spec_helper.rb'

describe FyberChallenge do
  def app
    @app ||= FyberChallenge
  end

  it 'should assert true' do
    expect(true).to be true
  end

  describe 'GET /' do
    it 'should allow accessing the home page' do
      get '/'
      expect(last_response).to be_ok
    end
    it 'should show proper welcome message' do
      get '/'
      expect(last_response.body).to include 'Ruby Developer Challenge'
    end
  end
end
