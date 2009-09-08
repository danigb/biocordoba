xml.instruct!
xml.sectors{ 
  @sectors.each do |s|
    xml.sector do
      xml.id(s.id)
      xml.name do
        xml.es(s.name)
        xml.en(s.english_name)
      end
    end
  end
}
