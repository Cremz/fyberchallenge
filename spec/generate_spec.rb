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
      expect(last_response.body).to include 'The uid parameter is required'
    end

    it 'should return proper response from api if results are found' do
      stub_request(:get, /.*api\.sponsorpay\.com\/feed\/v1\/offers\.json.*/)
        .to_return(status: 200, body: '{ "code": "OK",
          "message": "OK",
          "count": 1,
          "pages": 1,
          "information": {
          "app_name": "SP Test App" ,
          "appid": 157,
          "virtual_currency": "Coins",
          "country": " US" ,
          "language": " EN" ,
          "support_url": "http://iframe.sponsorpay.com/mobile/DE/157/my_offers"
          },
          "offers": [
          {
          "title": "Tap  Fish",
          "offer_id": 13554,
          "teaser": "Download and START" ,
          "required_actions": "Download and START",
          "link": "http://iframe.sponsorpay.com/mbrowser?appid=157&lpid=11387&uid=player1",
          "offer_types": [
           {
            "offer_type_id": 101,
            "readable": "Download"
           },
           {
            "offer_type_id": 112,
            "readable": "Free"
           }
          ] ,
          "thumbnail": {
           "lowres": "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png",
           "hires": "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_175.png"
          },
          "payout": 90,
          "time_to_payout": {
             "amount": 1800,
             "readable": "30 minutes"
            }
          }
          ]
        }', headers: {})
      post '/generate', uid: 'player1', pub0: 'campaign2', page: '1'
      expect(last_response.body).to include 'Found a total of 1 pages, showing the first 1 results.'
      expect(last_response.body).to include 'alert-success'
    end

    it 'should return proper response from api if no results are found' do
      stub_request(:get, /.*api\.sponsorpay\.com\/feed\/v1\/offers\.json.*/)
        .to_return(status: 200, body: '{ "code": "NO_CONTENT",
          "message": "Successful request, but no offers are currently available for this user"
        }', headers: {})
      post '/generate', uid: 'player1', pub0: 'campaign2', page: '1'
      expect(last_response.body).to include 'Successful request, but no offers are currently available for this user'
      expect(last_response.body).to include 'alert-info'
    end
    it 'should return proper response from api if there is an error' do
      stub_request(:get, /.*api\.sponsorpay\.com\/feed\/v1\/offers\.json.*/)
        .to_return(status: 200, body: '{ "code": "ERROR_INVALID_APPID",
          "message": "An invalid application id (appid) was given as a parameter in the request."
        }', headers: {})
      post '/generate', uid: 'player1', pub0: 'campaign2', page: '1'
      expect(last_response.body).to include 'An invalid application id (appid) was given as a parameter in the request.'
      expect(last_response.body).to include 'alert-danger'
    end

  end
end
