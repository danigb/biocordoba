xml.instruct!
xml.exhibitors{ 
  @users.each do |u|
    xml.exhibitor do
      xml.id(u.id)
      xml.company_name(u.profile.company_name)
    end
  end
}
