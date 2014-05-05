require 'util/JSONable'

class News < JSONable


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

end
