require 'open-uri'
require 'nokogiri'



class WordCount

def initialize()

 @counts = Hash.new(0)
end

def words_from_string(string)
  string.downcase.scan(/[\w']+/)
end

def count_frequency(word_list)

  for word in word_list
    if(word.length>4)
    @counts[word] += 1
  end
  end
  @counts
end

  def get_page_word_count(url)

    begin
     doc = Nokogiri::HTML(open(url))

    entries = doc.css('div.entry-content')

    entries.each do |entry|
    words = words_from_string(entry.content)
    count_frequency(words)
    end

    sorted  = Hash[@counts.sort_by { |word, count| count }.reverse[0..50]]
     rescue RuntimeError => error
      puts error
    end
  end

end
