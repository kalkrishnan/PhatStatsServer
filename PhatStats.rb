 require 'nokogiri'
  require 'open-uri'

require 'rubygems'

require 'net/http'

require 'sinatra'

require 'open-uri'

require 'rss'

require 'json'

require 'sinatra/cross_origin'

require 'xmlsimple'
require 'lib/news/news_factory'
require 'lib/util/word_cloud_entry'

require 'rubygems'
require 'sinatra/base'
require 'mechanize'



enable :sessions
set :server, 'webrick'
configure do

  $i=0

  @@nflplayers = Net::HTTP.get(URI.parse("http://www.fantasyfootballnerd.com/service/players/json/test/")).to_s

  @@json_result =JSON.parse(@@nflplayers)

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

    newsFactory = NewsFactory.new

    cross_origin

    newsFactory.build_news_repo 'http://www.nfl.com/rss/rsslanding?searchString=home'
   # url = 'http://www.nfl.com/rss/rsslanding?searchString=home'

   # get_rss_feed url

  end


  get '/LatestPlayer' do

    newsFactory = NewsFactory.new

    cross_origin

    newsFactory.build_player_news_repo('https://news.google.com/news?pz=1&cf=all&ned=us&hl=en&q='+request.query_string.split('playerName=')[1]+'%20NFL&output=rss')


  end

   get '/PlayerWordCount' do

    newsFactory = NewsFactory.new
    wordCount = WordCount.new
    cross_origin

     @counts = Hash.new(0)
     @wordcounts = Set.new()
    json_news = JSON.parse(get_rss_feed 'https://news.google.com/news?pz=1&cf=all&ned=us&hl=en&q='+request.query_string.split('playerName=')[1]+'%20NFL&output=rss')

     json_news["channel"]["item"].first(9).each do |entry|

      url = entry["link"].split("url=")[1]
      words = wordCount.get_page_word_count(url)
      if(words)
      words.each do |word, count|

        if(@counts[word])
          @counts[word] += count
        else
          @counts[word] = count
        end
      end
    end
    end
    @counts.each do |word, count|
      wordEntry = WordCloudEntry.new(word, count)
      @wordcounts.add(wordEntry)
    end

    to_json
  end

  get '/PlayerInfo' do
    cross_origin
     playerInfo = Hash.new(0)
    page = Nokogiri::HTML(open('http://search.espn.go.com/'+request.query_string.split('playerName=')[1]))
    player_pic = page.css("div.card-img img")
    player_pic.each{|link| playerInfo['image']=link['src'] }

     stats = page.css("div#playerInfo div table tr th")
     values = page.css("div#playerInfo div table tr td")
      puts stats
     puts values
     stats[0..4].zip(values[0..4]).each{|stat, value|

      playerInfo[stat.text]=value.text}

     playerInfo.to_json

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


  def to_json
    String words = "[";
    i = 0;

   @wordcounts.each{|word_entry|

      words = words + word_entry.to_json+ ",";
    }
    words = words[0..-2] +"]"
  end

