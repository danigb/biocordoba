require "scrapi"
require "pp"
# desc "Importación de idiomas" 
# task :load_languages => :environment do
# 
#   index = Scraper.define do
#     array :languages
#     process "li", :languages => :text
#     result :languages
#   end
# 
#   uri = URI.parse("http://es.wiktionary.org/wiki/Wikcionario:Lista_de_lenguas")
#   Language.delete_all
#   index.scrape(uri)[0..118].each do |e|
#     lang, code = e.split(" - ")
#     lang.gsub!(/\s\(.*\)/, "")
#     Language.create(:name => lang, :code => code)
#   end
# end

desc "Importación de Paises"
task :load_countries => :environment do
  index = Scraper.define do
    array :countries
    process "p", :countries => :text
    result :countries
  end

  uri = URI.parse("http://stneasy.cas.org/html/spanish/helps/2search/2A4ctrycodes.htm")
  Country.delete_all
  countries = []
  index.scrape(uri).each do |e|
    res = e.split(" ")
    code = res[0]
    name = res[1..-1].join(" ").extract_acute
    countries << [name, code]
    # Country.create(:name => name.extract_acute, :code => code)
  end

  File.open(File.join(RAILS_ROOT, "lib", 'countries.yml'), 'w' ) do |out|
    YAML.dump(countries, out )
  end

end
