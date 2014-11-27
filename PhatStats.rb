require 'rubygems'
require 'net/http'
require 'sinatra'
require 'open-uri'
require 'rss'
require 'json'
require 'sinatra/cross_origin'
require 'xmlsimple'
require 'infinispan-ruby-client'

enable :sessions

configure do

  $i=0
  $http = Net::HTTP.new('localhost', 8080)
  $http.post('/rest/default/nflplayers' ,Net::HTTP.get(URI.parse("http://www.fantasyfootballnerd.com/service/players/json/u9g87qqy69ux/")).to_s,  {"Content-Type" => "application/json"})
  $http.post('/rest/default/nflteams' ,Net::HTTP.get(URI.parse('http://www.fantasyfootballnerd.com/service/nfl-teams/json/u9g87qqy69ux/')).to_s,  {"Content-Type" => "application/json"})
 # @@nflplayers = Net::HTTP.get(URI.parse("http://www.fantasyfootballnerd.com/service/players/json/u9g87qqy69ux/")).to_s
#  json_result =JSON.parse(@@nflplayers)
end

get '/NFLTeams' do

  cross_origin
  $http = Net::HTTP.new('localhost', 8080)
  $http.get("/rest/default/nflteams").body
end

get '/NFLPlayers' do

  cross_origin
  $http.get("/rest/default/nflplayers").body
  #@@nflplayers
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
