require 'rspec/autorun'

require 'spec_helper'

describe PhatStats do

 describe "#get_rss_feed" do
    it "parses the RSS feed and returns a list of news objects" do
        @book.should be_an_instance_of Book
    end
 end
end
