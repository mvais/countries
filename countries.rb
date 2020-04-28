require 'nokogiri'
require 'open-uri'
require 'json'

class Countries
  COUNTRIES_URL = "https://www.nationsonline.org/oneworld/country_code_list.htm"

  def self.countries
    @@countries ||= self.scrape_countries
  end

  def self.json
    open("countries.json", "w") do |f|
      f.puts self.countries.to_json
    end
  end

  private

  def self.scrape_countries
    doc  = Nokogiri::HTML(open(COUNTRIES_URL))
    rows = doc.css("table#CountryCode tr").select { |row| row.children.count == 11 }
    countries = []

    rows.each do |row|
      data = row.css("td")

      countries.push({
        name: data[1].text.strip,
        alpha2: data[2].text.strip,
        alpha3: data[3].text.strip,
        code: data[4].text.strip,
        flag: "https://www.countryflags.io/#{data[2].text.strip}/flat/32.png"
      })
    end

    @@countries = self.clean(countries)
  end

  def self.clean(countries)
    countries.each do |country|
      country[:name] = "Vietnam"     if country[:alpha3] == "VNM"
      country[:name] = "Venezuela"   if country[:alpha3] == "VEN"
      country[:name] = "Tanzania"    if country[:alpha3] == "TZA"
      country[:name] = "Taiwan"      if country[:alpha3] == "TWN"
      country[:name] = "Syria"       if country[:alpha3] == "SYR"
      country[:name] = "Russia"      if country[:alpha3] == "RUS"
      country[:name] = "Micronesia"  if country[:alpha3] == "FSM"
      country[:name] = "Macedonia"   if country[:alpha3] == "MKD"
      country[:name] = "South Korea" if country[:alpha3] == "KOR"
      country[:name] = "North Korea" if country[:alpha3] == "PRK"
      country[:name] = "Iran"        if country[:alpha3] == "IRN"
      country[:name] = "Hong Kong"   if country[:alpha3] == "HKG"
    end

    countries
  end
end

Countries.json
