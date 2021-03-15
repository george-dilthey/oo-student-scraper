require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = page.css('div.student-card')
    students.map do |s|
      name = s.css('div.card-text-container h4').text
      location = s.css('div.card-text-container p').text
      profile_url = s.css('a').attribute('href').value
      {:name => name, :location => location, :profile_url => profile_url }

    end
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student = {}
    student[:profile_quote] = page.css('div.profile-quote').text
    student[:bio] = page.css('div.bio-content div.description-holder p').text

    socials = page.css('div.social-icon-container a')
    socials.each do |s|
      link = s.attribute('href').value
      if link.match(/twitter/) 
        student[:twitter] = link
      elsif link.match(/linkedin/) 
        student[:linkedin] = link
      elsif link.match(/github/) 
        student[:github] = link
      else 
        student[:blog] = link
      end
    end
    student

  end


end

# scrape = Scraper.scrape_profile_page('students/ryan-johnson.html')
# scrape