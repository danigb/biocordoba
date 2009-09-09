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

desc "Importación de Paises"
task :load_countries => :environment do
  index = Scraper.define do
    array :countries
    process "p", :countries => :text
    result :countries
  end

  uri = URI.parse("http://www.europarl.europa.eu/transl_es/plataforma/pagina/maletin/colecc/glosario/pe/paises.htm")
  Language.delete_all
  index.scrape(uri)[0..118].each do |e|
    lang, code = e.split(" - ")
    lang.gsub!(/\s\(.*\)/, "")
    Language.create(:name => lang, :code => code)
  end
end
