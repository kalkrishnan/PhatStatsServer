require 'json'

class WordCloudEntry


  def initialize(word, weight)

    @word = word
    @weight = weight

  end

  def get_word
    @word
  end

  def get_weight
    @weight
  end



 def to_json(*a)
    {
      "text" => @word, "weight" => @weight
    }.to_json(*a)
  end


end
