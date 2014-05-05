require 'rubygems'
require 'net/http'
require 'sinatra'
require 'open-uri'
require 'rss'
require 'json'
require 'sinatra/cross_origin'
require 'xmlsimple'


enable :sessions
configure do
  $i=0
  @@nflplayers = Net::HTTP.get(URI.parse("http://api.espn.com/v1/sports/football/nfl/athletes/?offset="+$i.to_s+"&apikey=4jwg9fbsuwv2ajmuvym22jmr")).to_s
  json_result =JSON.parse(@@nflplayers)
  resultsCount = json_result["resultsCount"]
  @@nflplayers = "{\"players\":["+@@nflplayers+","
  $i = $i+50
  while $i < 100 do

      sleep(0.300)
      @@nflplayers = @@nflplayers+Net::HTTP.get(URI.parse("http://api.espn.com/v1/sports/football/nfl/athletes/?offset="+$i.to_s+"&apikey=4jwg9fbsuwv2ajmuvym22jmr")).to_s+","
      $i = $i+50
    end
    $i = $i-50
    @@nflplayers = @@nflplayers+Net::HTTP.get(URI.parse("http://api.espn.com/v1/sports/football/nfl/athletes/?offset="+$i.to_s+"&apikey=4jwg9fbsuwv2ajmuvym22jmr")).to_s+"]}"

  end

  get '/NFLTeams' do

    cross_origin
    get_nfl_resource 'http://api.espn.com/v1/sports/football/nfl/teams/?apikey=4jwg9fbsuwv2ajmuvym22jmr'
  end

  get '/NFLPlayers' do

    cross_origin
    @@nflplayers
  end

  get '/Latest' do

    cross_origin
    url = 'http://www.nfl.com/rss/rsslanding?searchString=home'
    get_rss_feed url
  end


  def get_rss_feed(url)

    rss = open(url).read
    js = XmlSimple.xml_in rss, { 'ForceArray' => false, 'KeyToSymbol' => true}
    JSON.pretty_generate(js)
  end

  def get_nfl_resource(url)

    result = Net::HTTP.get(URI.parse(url))
    result.to_s
  end
