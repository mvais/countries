require 'nokogiri'
require 'open-uri'
require 'json'
require 'pry'

class Countries
  COUNTRIES_URL = "https://www.nationsonline.org/oneworld/country_code_list.htm"

  def self.countries
    @@countries ||= self.scrape_countries
  end

  def self.json
    open('countries.json', 'w') do |f|
      f.puts @@countries.to_json
    end
  end

  private

  def self.scrape_countries
    doc  = Nokogiri::HTML(open(COUNTRIES_URL))
    rows = doc.css('table#CountryCode tr').select { |row| row.children.count == 11 }
    countries = []

    rows.each do |row|
      data = row.text.split("\n").reject(&:empty?)

      countries.push({
        name: data[0].strip,
        alpha2: data[1].strip,
        alpha3: data[2].strip,
        code: data[3].strip
      })
    end

    @@countries = countries
  end
end
