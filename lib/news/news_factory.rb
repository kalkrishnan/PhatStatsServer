require 'set'

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

  def json_news
    String news = "{\"news\":[";
    i = 0;
    while(!@news.empty? && i<5)
      news = news + @news[i].to_json + ",";
    end
    news = news[0..-2] +"]}"
  end

  def build_news_repo
    json_news = JSON.parse(get_rss_feed 'http://www.nfl.com/rss/rsslanding?searchString=home')
    json_news["entry"].each do |entry|
      @news.add(News.new(entry["title"],entry["summary"],entry["creator"],entry["images"]))
    end
  end

  def get_rss_feed(url)
    rss = open(url).read
    js = XmlSimple.xml_in rss, { 'ForceArray' => false, 'KeyToSymbol' => true}
    JSON.pretty_generate(js)
  end


end
