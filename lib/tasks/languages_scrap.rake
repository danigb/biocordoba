require "scrapi"
desc "Importación de idiomas" 
task :load_languages => :environment do

  index = Scraper.define do
    array :languages
    process "li", :languages => :text
    result :languages
  end

  uri = URI.parse("http://es.wiktionary.org/wiki/Wikcionario:Lista_de_lenguas")
  Language.delete_all
  index.scrape(uri)[0..118].each do |e|
    lang, code = e.split(" - ")
    lang.gsub!(/\s\(.*\)/, "")
    Language.create(:name => lang, :code => code)
  end
end
