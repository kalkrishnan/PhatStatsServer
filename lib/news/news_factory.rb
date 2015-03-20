require 'set'
require 'mechanize'
require 'json'
require 'lib/util/word_count'

require_relative 'news'

class NewsFactory


  def initialize()

    @news = Set.new
    @wordCount = WordCount.new
  end

  def get_top_news

    if(!@news.empty?)
      json_news
    elsif
      build_news_repo
    end
  end


  def build_news_repo url
    json_news = JSON.parse(get_rss_feed url)

    json_news["entry"].each do |entry|
      @news.add(News.new(entry["title"],entry["summary"],entry["creator"],entry["images"]))
    end

    get_json_news
  end

    def build_player_news_repo url
    json_news = JSON.parse(get_rss_feed url)

    json_news["channel"]["item"].first(9).each do |entry|

      url = entry["link"].split("url=")[1]

          if(url.include? "com")
             url = url[0...url.index("com/")+3]
          elsif(url.include? "ca")
             url = url[0...url.index("ca/")+3]
          end

      @news.add(News.new(entry["title"],entry["description"]["content"], url, nil))
    end

    get_json_news
  end

  def get_json_news
    String news = "[{\"topic\":\"news\",\"items\":[";
    i = 0;

   @news.each{|news_entry|

      news = news + news_entry.to_json+ ",";
    }
    news = news[0..-2] +"]}]"
  end

  def get_rss_feed(url)

    rss = open(url).read
    js = XmlSimple.xml_in rss, { 'ForceArray' => false, 'KeyToSymbol' => true}

    JSON.pretty_generate(js)

  end

end
