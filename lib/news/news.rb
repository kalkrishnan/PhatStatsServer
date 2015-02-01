require 'json'

class News


  def initialize(_headline, _description, _author, _image)

    @headline = _headline
    @description = _description
    @author = _author
    @image = _image

  end

  def get_headline
    @headline
  end

  def get_description
    @description
  end

  def get_author
    @author
  end

  def get_image
    @image
  end

 def to_json(*a)
    {
      "headline" => @headline, "description" => @description , "author" => @author , "image" => @image
    }.to_json(*a)
  end


end
