xml.instruct!
xml.exhibitors{ 
  @users.each do |u|
    xml.exhibitor do
      xml.id(u.id)
      xml.name(u.profile.company_name)
    end
  end
}
