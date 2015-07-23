require 'spec_helper.rb'

describe FyberChallenge do
  def app
    @app ||= FyberChallenge
  end

  describe 'POST /generate' do
    it 'should return error if params are not sent' do
      post '/generate', {}
      expect(last_response.body).to include 'No parameters were sent'
    end

    it 'should return error if any params are blank' do
      post '/generate',  uid: ''
      expect(last_response.body).to include 'Please fill all the required values'
    end

    it 'should return proper response from api' do
      stub_request(:get, /.*api\.sponsorpay\.com\/feed\/v1\/offers\.json.*/)
        .to_return(status: 200, body: 'message: "Successful request."', headers: {})
      post '/generate', uid: 'player1', pub0: 'campaign2', page: '1'

      expect(last_response.body).to include 'Successful request'
    end
  end
end
