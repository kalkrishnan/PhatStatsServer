require 'set'
require_relative 'news'

class NewsFactory


  def initialize()

    @news = Set.new
  end

  def get_top_news

    if(!@news.empty?)
      json_news
    elsif
      build_news_repo
    end
  end


  def build_news_repo
    json_news = JSON.parse(get_rss_feed 'http://www.nfl.com/rss/rsslanding?searchString=home')
    json_news["entry"].each do |entry|
      @news.add(News.new(entry["title"],entry["summary"],entry["creator"],entry["images"]))
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
