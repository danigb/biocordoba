xml.instruct!
xml.exhibitor do
  xml.id(@exhibitor.id)
  xml.name(@profile.company_name)
  xml.address(@profile.address)
  xml.zip_code(@profile.zip_code)
  xml.town(@profile.town_name)
  xml.province(@profile.province_name)
  xml.phone(@profile.phone)
  xml.fax(@profile.fax)
  xml.email(@exhibitor.email)
  xml.web(@profile.website)
  xml.stand(@profile.stand)
  xml.sectors do
    @profile.sectors.each do |s|
      xml.name((params[:lang].present? && params[:lang] == "en") ? s.english_name : s.name)
    end
  end  
end
